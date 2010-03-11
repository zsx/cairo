# vim: ft=python expandtab
import os
import re
from site_init import GBuilder, Initialize

opts = Variables()
opts.Add(PathVariable('PREFIX', 'Installation prefix', os.path.expanduser('~/FOSS'), PathVariable.PathIsDirCreate))
opts.Add(BoolVariable('DEBUG', 'Build with Debugging information', 0))
opts.Add(PathVariable('PERL', 'Path to the executable perl', r'C:\Perl\bin\perl.exe', PathVariable.PathIsFile))
opts.Add(BoolVariable('WITH_OSMSVCRT', 'Link with the os supplied msvcrt.dll instead of the one supplied by the compiler (msvcr90.dll, for instance)', 0))

env = Environment(variables = opts,
                  ENV=os.environ, tools = ['default', GBuilder])

Initialize(env)
env.Append(CPPPATH=['#'])
env.Append(CFLAGS=env['DEBUG_CFLAGS'])
env.Append(CPPDEFINES=env['DEBUG_CPPDEFINES'])

if env['WITH_OSMSVCRT']:
    env['LIB_SUFFIX'] = '-2'

env.Alias('install', env.Install('$PREFIX/include/cairo', 'cairo-version.h'))

env['CAIRO_VERSION'] = '1.9.3'
env['DOT_IN_SUBS'] = {'@VERSION@': env['CAIRO_VERSION']}
env.DotIn('config.h', 'config.h.in')
SConscript(['src/SConscript'], exports = 'env')
