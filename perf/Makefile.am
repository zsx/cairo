include $(top_srcdir)/build/Makefile.am.common

AM_CPPFLAGS =					\
	-I$(srcdir)				\
	-I$(top_srcdir)/boilerplate		\
	-I$(top_srcdir)/src			\
	-I$(top_srcdir)/util/cairo-script	\
	-I$(top_builddir)/src			\
	$(CAIRO_CFLAGS)

AM_LDFLAGS = $(CAIRO_LDFLAGS)

EXTRA_PROGRAMS += cairo-perf \
		  cairo-perf-trace \
		  cairo-perf-diff-files \
		  cairo-perf-print \
		  cairo-perf-chart \
		  cairo-perf-compare-backends \
		  cairo-perf-graph-files
EXTRA_DIST += cairo-perf-diff COPYING
EXTRA_LTLIBRARIES += libcairoperf.la

LDADD = libcairoperf.la \
	$(top_builddir)/boilerplate/libcairoboilerplate.la \
	$(top_builddir)/src/libcairo.la \
	$(CAIROPERF_LIBS)

cairo_perf_SOURCES =		\
	cairo-perf.c		\
	cairo-perf.h		\
	cairo-perf-cover.c	\
	box-outline.c		\
	composite-checker.c	\
	fill.c			\
	long-lines.c		\
	mosaic.c		\
	mosaic.h		\
	paint.c			\
	paint-with-alpha.c	\
	mask.c			\
	pattern_create_radial.c \
	rectangles.c		\
	rounded-rectangles.c	\
	stroke.c		\
	subimage_copy.c		\
	tessellate.c		\
	text.c			\
	glyphs.c		\
	twin.c			\
	unaligned-clip.c	\
	world-map.c		\
	world-map.h		\
	zrusin.c		\
	zrusin-another.h	\
	long-dashed-lines.c	\
	dragon.c		\
	pythagoras-tree.c	\
	intersections.c		\
	spiral.c

if CAIRO_HAS_WIN32_SURFACE
cairo_perf_SOURCES += cairo-perf-win32.c
else
if CAIRO_HAS_OS2_SURFACE
cairo_perf_SOURCES += cairo-perf-os2.c
else
cairo_perf_SOURCES += cairo-perf-posix.c
endif
endif
cairo_perf_LDADD = $(LDADD)
cairo_perf_DEPENDENCIES = \
        $(top_builddir)/boilerplate/libcairoboilerplate.la	\
	$(top_builddir)/src/libcairo.la \
	libcairoperf.la

libcairoperf_la_SOURCES = \
	cairo-perf-report.c	\
	cairo-stats.c		\
	cairo-stats.h

cairo_perf_trace_SOURCES =		\
	cairo-perf-trace.c
if CAIRO_HAS_WIN32_SURFACE
cairo_perf_trace_SOURCES += cairo-perf-win32.c
else
if CAIRO_HAS_OS2_SURFACE
cairo_perf_trace_SOURCES += cairo-perf-os2.c
else
cairo_perf_trace_SOURCES += cairo-perf-posix.c
endif
endif
cairo_perf_trace_LDADD =		\
	$(top_builddir)/util/cairo-script/libcairo-script-interpreter.la \
	$(LDADD)
cairo_perf_trace_DEPENDENCIES = \
	$(top_builddir)/util/cairo-script/libcairo-script-interpreter.la \
        $(top_builddir)/boilerplate/libcairoboilerplate.la	\
	$(top_builddir)/src/libcairo.la \
	libcairoperf.la

cairo_perf_diff_files_SOURCES =	\
	cairo-perf-diff-files.c

cairo_perf_print_SOURCES =	\
	cairo-perf-print.c

cairo_perf_chart_SOURCES =	\
	cairo-perf-chart.c

cairo_perf_compare_backends_SOURCES =	\
	cairo-perf-compare-backends.c

cairo_perf_graph_files_SOURCES = \
	cairo-perf-graph.h \
	cairo-perf-graph-files.c \
	cairo-perf-graph-widget.c
cairo_perf_graph_files_CFLAGS = @gtk_CFLAGS@
cairo_perf_graph_files_LDADD = @gtk_LIBS@ $(LDADD)

# Install rules to rebuild the libraries and add explicit dependencies
$(top_builddir)/boilerplate/libcairoboilerplate.la: $(top_builddir)/src/libcairo.la
	cd $(top_builddir)/boilerplate && $(MAKE) $(AM_MAKEFLAGS) libcairoboilerplate.la

$(top_builddir)/src/libcairo.la:
	cd $(top_builddir)/src && $(MAKE) $(AM_MAKEFLAGS) libcairo.la

$(top_builddir)/util/cairo-script/libcairo-script-interpreter.la: $(top_builddir)/src/libcairo.la
	cd $(top_builddir)/util/cairo-script && $(MAKE) $(AM_MAKEFLAGS) libcairo-script-interpreter.la


# Do a funny transition of CAIRO_TEST_TARGET through TARGETS such that
# one can limit tested targets both through CAIRO_TEST_TARGET env var
# and TARGETS make var on the command line.  Same for the rest.
TARGETS = $(CAIRO_TEST_TARGET)
TARGETS_EXCLUDE = $(CAIRO_TEST_TARGET_EXCLUDE)
ITERS = $(CAIRO_PERF_ITERATIONS)

CAIRO_PERF_ENVIRONMENT = CAIRO_PERF_ITERATIONS="$(ITERS)" CAIRO_TEST_TARGET="$(TARGETS)" CAIRO_TEST_TARGET_EXCLUDE="$(TARGETS_EXCLUDE)"

# Cap the maximum number of iterations during 'make check'
TESTS_ENVIRONMENT = CAIRO_TEST_TARGET="$(TARGETS)" CAIRO_PERF_ITERATIONS="10"

TESTS += cairo-perf$(EXEEXT)

perf: cairo-perf$(EXEEXT) cairo-perf-trace$(EXEEXT)
	-$(CAIRO_PERF_ENVIRONMENT) ./cairo-perf$(EXEEXT)
	-$(CAIRO_PERF_ENVIRONMENT) ./cairo-perf-trace$(EXEEXT)

html-local: index.html

perf-tag.html : cairo-perf${EXEEXT}
	$(CAIRO_PERF_ENVIRONMENT) ./cairo-perf-diff -t -h $@ `git describe --abbrev=0` HEAD
perf-commit.html : cairo-perf${EXEEXT}
	$(CAIRO_PERF_ENVIRONMENT) ./cairo-perf-diff -t -h $@ HEAD

# Summarise changes in index.html, with details in links
index.html: perf-tag.html perf-commit.html
	echo "<html><head><title>Performance Changes</title></head><body>Against <a href=\"perf-tag.html\">"`git describe --abbrev=0`"</a><br><a href=\"perf-commit.html\">Latest commit</a></body>" > $@

EXTRA_VALGRIND_FLAGS = $(CAIRO_EXTRA_VALGRIND_FLAGS)
VALGRIND_MEMCHECK_FLAGS = \
	--tool=memcheck \
	--suppressions=$(top_srcdir)/test/.valgrind-suppressions \
	--leak-check=yes --show-reachable=yes
VALGRIND_CALLGRIND_FLAGS = \
	--tool=callgrind
CLEANFILES += \
	valgrind-log \
	callgrind.out.* \
	index.html

check-valgrind perf-valgrind:
	$(MAKE) $(AM_MAKEFLAGS) check \
	    TESTS_ENVIRONMENT='$(TESTS_ENVIRONMENT) \
	    $(top_builddir)/libtool --mode=execute \
	    valgrind $(VALGRIND_MEMCHECK_FLAGS) $(EXTRA_VALGRIND_FLAGS)' \
	    | tee valgrind-log

perf-callgrind:
	$(MAKE) $(AM_MAKEFLAGS) check \
	    TESTS_ENVIRONMENT='$(TESTS_ENVIRONMENT) \
	    $(top_builddir)/libtool --mode=execute \
	    valgrind $(VALGRIND_CALLGRIND_FLAGS) $(EXTRA_VALGRIND_FLAGS)'

.PHONY: perf check-valgrind perf-valgrind perf-callgrind

EXTRA_DIST += Makefile.win32
