# -*- coding: utf-8 -*-
#
# totor documentation build configuration file, created by
# sphinx-quickstart on Mon Jan 24 17:33:44 2011.
#
# This file is execfile()d with the current directory set to its containing dir.
#
# Note that not all possible configuration values are present in this
# autogenerated file.
#
# All configuration values have a default; values that are commented out
# serve to show the default.

from __future__ import absolute_import, print_function

import sys, os
import datetime
import subprocess
import glob

import six

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#sys.path.append(os.path.abspath('.'))
try:
    import matplotlib
    sys.path.append( os.path.abspath( os.path.join( os.path.dirname( os.path.dirname( matplotlib.__file__ ) ), 'sphinx', 'ext' ) ) )
except Exception as e:
    print('warning:', e)

# taken from soma-base
def find_in_path(file, path=None):
    '''
    Look for a file in a series of directories. By default, directories are
    contained in ``PATH`` environment variable. But another environment
    variable name or a sequence of directories names can be given in *path*
    parameter.

    Examples::

      find_in_path('sh') could return '/bin/sh'
      find_in_path('libpython2.7.so', 'LD_LIBRARY_PATH') could return '/usr/local/lib/libpython2.7.so'
    '''
    if path is None:
        path = os.environ.get('PATH').split(os.pathsep)
    elif isinstance(path, six.string_types):
        var = os.environ.get(path)
        if var is None:
            var = path
        path = var.split(os.pathsep)
    for i in path:
        p = os.path.normpath(os.path.abspath(i))
        if p:
            r = glob.glob(os.path.join(p, file))
            if r:
                return r[0]


# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
sys.path.insert(0,os.path.abspath('sphinxext'))

# -- General configuration -----------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be extensions
# coming with Sphinx (named 'sphinx.ext.*') or your custom ones.
try:
    # try napoleon which replaces numpydoc (and googledoc),
    # comes with sphinx 1.2
    import sphinx.ext.napoleon
    napoleon = 'sphinx.ext.napoleon'
except ImportError:
    # not available, fallback to numpydoc
    napoleon = 'numpy_ext.numpydoc'
extensions = ['sphinx.ext.autodoc',
              'sphinx.ext.intersphinx',
              'sphinx.ext.todo',
              'sphinx.ext.coverage',
              'sphinx.ext.ifconfig',
              'sphinx.ext.viewcode',
              'sphinx.ext.extlinks',
              'sphinx.ext.inheritance_diagram',
              'sphinx.ext.autosummary',
              napoleon]

todo_include_todos = True

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The suffix of source filenames.
source_suffix = '.rst'

# The encoding of source files.
#source_encoding = 'utf-8'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = u'BrainVisa-Cmake'
copyright = u'%s, CEA' % datetime.datetime.now().year

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = '2.1'
# The full version, including alpha/beta/rc tags.
release = '2.1.0'
try:
    from brainvisa_cmake import version as bcversion
    version = '%s.%s' % (bcversion.version_major, bcversion.version_minor)
    release = '%s.%s.%s' % (bcversion.version_major, bcversion.version_minor,
                            bcversion.version_patch)
except ImportError:
    pass

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#language = None

# There are two options for replacing |today|: either, you set today to some
# non-false value, then it is used:
#today = ''
# Else, today_fmt is used as the format for a strftime call.
#today_fmt = '%B %d, %Y'

# List of documents that shouldn't be included in the build.
#unused_docs = []

# List of directories, relative to source directory, that shouldn't be searched
# for source files.
exclude_trees = []

# The reST default role (used for this markup: `text`) to use for all documents.
#default_role = None

# If true, '()' will be appended to :func: etc. cross-reference text.
#add_function_parentheses = True

# If true, the current module name will be prepended to all description
# unit titles (such as .. function::).
#add_module_names = True

# If true, sectionauthor and moduleauthor directives will be shown in the
# output. They are ignored by default.
#show_authors = False

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'

# A list of ignored prefixes for module index sorting.
#modindex_common_prefix = []


# -- Options for HTML output ---------------------------------------------------

# The theme to use for HTML and HTML Help pages.  Major themes that come with
# Sphinx are currently 'default' and 'sphinxdoc'.
html_theme = 'default'

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
html_theme_options = {  }

# Add any paths that contain custom themes here, relative to this directory.
#html_theme_path = []

# The name for this set of Sphinx documents.  If None, it defaults to
# "<project> v<release> documentation".
#html_title = None

# A shorter title for the navigation bar.  Default is the same as html_title.
#html_short_title = None

# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
#html_logo = '../../../../axon/trunk/share/icons/brainvisa.png'

html_style = 'custom.css'

# The name of an image file (within the static path) to use as favicon of the
# docs.  This file should be a Windows icon file (.ico) being 16x16 or 32x32
# pixels large.
#html_favicon = '../../../../communication/web/trunk/gas/favicon.ico'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# If not '', a 'Last updated on:' timestamp is inserted at every page bottom,
# using the given strftime format.
#html_last_updated_fmt = '%b %d, %Y'

# If true, SmartyPants will be used to convert quotes and dashes to
# typographically correct entities.
#html_use_smartypants = True

# Custom sidebar templates, maps document names to template names.
# html_sidebars = { '**' : [ 'relations.html' ], }

# Additional templates that should be rendered to pages, maps page names to
# template names.
html_additional_pages = {}

# If false, no module index is generated.
html_use_modindex = True

# If false, no index is generated.
#html_use_index = True

# If true, the index is split into individual pages for each letter.
#html_split_index = False

# If true, links to the reST sources are added to the pages.
# html_show_sourcelink = True

# If true, an OpenSearch description file will be output, and all pages will
# contain a <link> tag referring to it.  The value of this option must be the
# base URL from which the finished HTML is served.
#html_use_opensearch = ''

# If nonempty, this is the file name suffix for HTML files (e.g. ".xhtml").
#html_file_suffix = ''

# Output file base name for HTML help builder.
htmlhelp_basename = 'brainvisa_cmake_doc'


# -- Options for LaTeX output --------------------------------------------------

# The paper size ('letter' or 'a4').
#latex_paper_size = 'letter'

# The font size ('10pt', '11pt' or '12pt').
#latex_font_size = '10pt'

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title, author, documentclass [howto/manual]).
latex_documents = [
  ('index', 'brainvisa_cmake.tex', u'BrainVisa-Cmake Documentation',
   u'someone', 'manual'),
]

# The name of an image file (relative to this directory) to place at the top of
# the title page.
#latex_logo = None

# For "manual" documents, if this is true, then toplevel headings are parts,
# not chapters.
#latex_use_parts = False

# Additional stuff for the LaTeX preamble.
#latex_preamble = ''

# Documents to append as an appendix to all manuals.
#latex_appendices = []

# If false, no module index is generated.
#latex_use_modindex = True

autoclass_content = "both"

extlinks = {
}

#import soma
#docpath = os.path.join( os.path.dirname( os.path.dirname( os.path.dirname( \
  #soma.__file__ ) ) ), 'share', 'doc' )

#intersphinx_mapping = {
  #'somabase': (os.path.join(docpath, 'soma-base-' + version + '/sphinx'), None),
  #'pyaims': (os.path.join(docpath, 'pyaims-' + version + '/sphinx'), None),
  #'pyana': (os.path.join(docpath, 'pyanatomist-' + version + '/sphinx'), None),
  #'aims': (os.path.join(docpath, 'aimsdata-' + version), None),
  #'python': ('https://docs.python.org/2.7', None),
#}

# ---- build help pages ---
bv_maker = find_in_path('bv_maker')
for subcmd in ('', 'info', 'sources', 'status', 'configure', 'build', 'doc', 'testref', 'test', 'pack', 'install_pack', 'testref_pack', 'test_pack', 'publish_pack'):
    cmd = [sys.executable, bv_maker]
    if subcmd == '':
        fname = 'bv_maker_help.rst'
    else:
        fname = 'bv_maker_help_%s.rst' % subcmd
        cmd.append(subcmd)
    cmd.append('-h')
    fname = os.path.join(os.path.dirname(__file__), fname)
    if sys.version_info[0] >= 3:
        ofile = open(fname, 'w', encoding='utf-8')
    else:
        ofile = open(fname, 'w')
    try:
        print('generate:', fname)
        subprocess.call(cmd, stdout=ofile)
    finally:
        ofile.close()
del ofile, cmd, subcmd, fname
