#!/usr/bin/env python3

from datetime   import datetime 
from pathlib    import Path
from multiprocessing import Pool
import subprocess
import multiprocessing as multi
import sys

class Optional(object):
    def __init__(self, value=None):
        self.value = value
        self.is_value = True
        if value is None:
            self.is_value = False
    
    def bind(self, func):
        if self.is_value:
            self = func(self.value)
        return self 

    def __str__(self):
        if self.is_value:
            return 'Some(' + str(self.value) + ')'
        else:
            return 'None'

class color:
    def _wrap_with(code):
        def inner(text, bold=False):
            c = code
            if bold:
                c = "1;%s" % c
            return "\033[%sm%s\033[0m" % (c, text)
        return inner
    
    red     = _wrap_with('31')
    green   = _wrap_with('32')
    yellow  = _wrap_with('33')
    blue    = _wrap_with('34')
    magenta = _wrap_with('35')
    cyan    = _wrap_with('36')
    white   = _wrap_with('37')

def simulation(file_name: str):
    filename_without_extention = file_name.split('/')[-1].split('.')[0]
    try:
        log_simulater = subprocess.getoutput(
            'vsim -c -keepstdout -do "add wave *;run -all;quit" %s 2>&1'  
            % filename_without_extention)
    except: 
        print((color.red('%s') + ': simulation failed') % file_name)
        print(log_simulater)
        return Optional()

    return Optional(log_simulater)

def compile(file_name: str):
    try:
        log_compiler = subprocess.getoutput("vlog -sv %s" % file_name)
    except: 
        print((color.red('%s') + ': compile failed') % file_name)
        print(log_compiler)
        return Optional()

    return Optional(log_compiler)

def parse_status(output_text: str):
    last_line = output_text.split('\n')[-1]
    errors_cnt, warnings_cnt = [
        int(s.split(':')[-1]) for s in last_line.split(',')]

    # [設計]
    # 解決方法がよくわからない上に
    # Verilogのコードの問題ではなさそうなので無視する
    # 無視しなくてもWarningとしてカウントされていない？
    '''
    if 'setting ADDR_NO_RANDOMIZE failed' in output_text:
        exclusive_ADDR_NO_RANDOMIZE_failed = True
    else:
        exclusive_ADDR_NO_RANDOMIZE_failed = False

    return (errors_cnt, warnings_cnt - exclusive_ADDR_NO_RANDOMIZE_failed)
    '''
    return (errors_cnt, warnings_cnt)

def is_test_succeeded(file_name: str):
    opt_log_compiler = compile(file_name)
    assert(opt_log_compiler.is_value)
    
    # コンパイル時にErrorかWarningを内包している場合出力を行う
    errors_cnt, warnings_cnt = parse_status(opt_log_compiler.value)
    if errors_cnt != 0 and warnings_cnt != 0:
        print((color.red('%s') + ': compile time errors: %d, warnings: %d')
            % (file_name, errors_cnt, warnings_cnt))
        print(opt_log_compiler.value)
        return False
    
    opt_log_simulater = simulation(file_name)
    assert(opt_log_simulater.is_value)
 
    # シュミレーション時にErrorかWarningを内包している場合出力を行う
    errors_cnt, warnings_cnt = parse_status(opt_log_simulater.value)
    if errors_cnt != 0 and warnings_cnt != 0:
        print((color.red('%s') + ': simulate time errors: %d, warnings: %d')
            % (file_name, errors_cnt, warnings_cnt))
        print(opt_log_simulater.value)
        return False
    
    # アサーション
    if 'Assertion' in opt_log_simulater.value:
        print((color.red('%s') + ': assertion error') % file_name)
        print(opt_log_simulater.value)
        return False
    
    # 問題が見つからないならpass
    print((color.green('%s') + ': succeeded') % file_name)
    return True

def test_all():
    print(datetime.now().strftime("test start: %Y/%m/%d %H:%M:%S "))

    source_file_names = [str(name) for name 
        in Path(__file__).parent.glob('test/**/*.sv')]
    
    count_test_succeeded_files = len([file_name 
        for file_name 
        in source_file_names
        if is_test_succeeded(file_name)])

    p = Pool(multi.cpu_count())
    count_test_succeeded_files = sum(
        p.map(is_test_succeeded, source_file_names))
    p.close()

    print("test succeed: %d/%d." 
        % (count_test_succeeded_files, len(source_file_names)))

    print(datetime.now().strftime("test end: %Y/%m/%d %H:%M:%S "))
    
    if count_test_succeeded_files < len(source_file_names):
        # テストが全て成功しなかった場合異常終了する
        sys.exit(1)

def test(file_path: str):
    print(datetime.now().strftime("test start: %Y/%m/%d %H:%M:%S "))
    opt_log_compiler = compile(file_path)
    print(opt_log_compiler.value)
    
    if opt_log_compiler.is_value:
        opt_log_simulater = simulation(file_path)
        print(opt_log_simulater.value)

    print(datetime.now().strftime("test end: %Y/%m/%d %H:%M:%S "))

def main():
    if   1 == len(sys.argv):
        test_all()
    elif 2 == len(sys.argv):
        test(sys.argv[1])
    else:
        print("Usage: ./test.py <filename> or ./test.py")

if __name__ == '__main__':
    main()
