#!/usr/bin/python

import optparse
import os
import shutil
import subprocess
import sys
import tempfile


def chunks(l, n):
    return [l[i:i+n] for i in range(0, len(l), n)]


def group(papersize, in_files, out_file):
    # TODO: optimise pdf? pdfopt was dropped - http://bugs.ghostscript.com/show_bug.cgi?id=694099
    subprocess.call(['gs', '-q', '-dNOPAUSE', '-dBATCH', '-sDEVICE=pdfwrite',
        '-sPAPERSIZE=' + papersize, '-sOutputFile=' + out_file, '-c', 'save', 'pop',
            '-f'] + in_files)


def main(args):
    parser = optparse.OptionParser("%prog papersize out_name file...")
    parser.add_option("--count", help='number of files to process at a time (defaults to all)',
            type='int')
    opts, args = parser.parse_args(args)
    papersize = args[0]
    out = args[1]
    in_files = args[2:]
    if opts.count:
        for i, in_files in enumerate(chunks(in_files, opts.count), 1):
            out_split = os.path.splitext(out)
            group(papersize, in_files, '%s.%d%s' % (out_split[0], i, out_split[1]))
    else:
        group(papersize, in_files, out)


def create_pdf(out):
    p = subprocess.Popen('enscript -q -o - | ps2pdf - -', shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    p.stdin.write('test')
    p.stdin.close()
    shutil.copyfileobj(p.stdout, open(out, 'w'))
    p.wait()


def test():
    wd = os.getcwd()
    tempdir = tempfile.mkdtemp()
    try:
        os.chdir(tempdir)

        create_pdf('in.1.pdf')
        create_pdf('in.2.pdf')
        main(['a4', 'out.pdf', 'in.1.pdf', 'in.2.pdf'])
        assert os.path.exists('out.pdf')
        # TODO: check file is 2 pages long
        #os.system('xdg-open out.pdf')

        create_pdf('in.3.pdf')
        create_pdf('in.4.pdf')

        main(['--count=2', 'a4', 'out.pdf', 'in.1.pdf', 'in.2.pdf', 'in.3.pdf', 'in.4.pdf'])
        assert os.path.exists('out.1.pdf')
        assert os.path.exists('out.2.pdf')

    finally:
        os.chdir(wd)
        shutil.rmtree(tempdir)


if __name__ == '__main__':
#    test()
    main(sys.argv[1:])

