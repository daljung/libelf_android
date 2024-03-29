# Makefile for libelf.
# Copyright (C) 1995 - 2005 Michael Riepe
# 
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Library General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.
# 
# You should have received a copy of the GNU Library General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

# @(#) $Id: Makefile.in,v 1.30 2008/05/23 08:17:56 michael Exp $

instroot =

prefix = /usr/local
exec_prefix = ${prefix}
libdir = ${exec_prefix}/lib

pkgdir = $(libdir)/pkgconfig

MV = mv -f
RM = rm -f
LN_S = ln -s
INSTALL = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644

CC = /home/indal.choi/bin/android-ndk-r7/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-gcc
CFLAGS = --sysroot=/home/indal.choi/bin/android-ndk-r7/platforms/android-9/arch-arm
CPPFLAGS = --sysroot=/home/indal.choi/bin/android-ndk-r7/platforms/android-9/arch-arm
LDFLAGS = 
LIBS = 

# no user serviceable parts below

PACKAGE = libelf
VERSION = 0.8.13

SHELL = /bin/sh


srcdir = .


SUBDIRS = lib 
DISTSUBDIRS = lib po

DISTFILES = \
	acconfig.h aclocal.m4 ChangeLog config.guess config.h.in \
	config.sub configure configure.in COPYING.LIB INSTALL install-sh \
	Makefile.in mkinstalldirs README stamp-h.in VERSION libelf.pc.in

all: all-recursive all-local
check: check-recursive check-local
install: install-recursive install-local
uninstall: uninstall-recursive uninstall-local
mostlyclean: mostlyclean-recursive mostlyclean-local
clean: clean-recursive clean-local
distclean: distclean-recursive distclean-local
maintainer-clean: maintainer-clean-recursive maintainer-clean-local

install-compat uninstall-compat:
	cd lib && $(MAKE) $@

all-recursive check-recursive install-recursive uninstall-recursive \
clean-recursive distclean-recursive mostlyclean-recursive \
maintainer-clean-recursive:
	@subdirs="$(SUBDIRS)"; for subdir in $$subdirs; do \
	  target=`echo $@|sed 's,-recursive,,'`; \
	  echo making $$target in $$subdir; \
	  (cd $$subdir && $(MAKE) $$target) || exit 1; \
	done

all-local:

check-local:

install-local: $(srcdir)/mkinstalldirs libelf.pc
	$(SHELL) $(srcdir)/mkinstalldirs $(instroot)$(pkgdir)
	$(INSTALL_DATA) libelf.pc $(instroot)$(pkgdir)

uninstall-local:
	$(RM) $(instroot)$(pkgdir)/libelf.pc

mostlyclean-local:
	$(RM) *~ core errlist

clean-local: mostlyclean-local

distclean-local: clean-local
	$(RM) config.cache config.h config.log config.status stamp-h
	$(RM) Makefile
	$(RM) libelf.pc

maintainer-clean-local: distclean-local
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."
	$(RM) config.h.in configure stamp-dist
	$(RM) -r $(distdir)

# maintainer only

MAINT = maintainer-only-

distdir = $(PACKAGE)-$(VERSION)
DISTPERMS = --owner=root --group=root --numeric-owner
$(MAINT)dist: ./stamp-dist
$(MAINT)./stamp-dist: $(DISTFILES)
	$(RM) -r $(distdir)
	mkdir $(distdir)
	files="$(DISTFILES)"; for file in $$files; do \
	  ln $(srcdir)/$$file $(distdir) || \
	    cp -p $(srcdir)/$$file $(distdir) || exit 1; \
	done
	subdirs="$(DISTSUBDIRS)"; for subdir in $$subdirs; do \
	  (cd $$subdir && $(MAKE) dist) || exit 1; \
	done
	cd $(distdir) && \
	    find . -type f ! -name MANIFEST -exec wc -c {} \; | \
	    sed 's, \./, ,' | sort -k2 >MANIFEST
	-$(RM) $(distdir).tar.gz.bak $(PACKAGE).tar.gz
	-$(MV) $(distdir).tar.gz $(distdir).tar.gz.bak
	tar cvohfz $(distdir).tar.gz $(DISTPERMS) $(distdir)
	$(LN_S) $(distdir).tar.gz $(PACKAGE).tar.gz
	$(RM) stamp-dist && echo timestamp > stamp-dist

$(MAINT)check-dist:
	$(RM) -r disttest
	mkdir disttest
	@echo 'unset CC CFLAGS CPPFLAGS LDFLAGS LIBS' >disttest/config.site
	cd disttest && CONFIG_SITE=config.site ../$(distdir)/configure
	$(MAKE) -C disttest
	$(MAKE) -C disttest check
	$(MAKE) -C disttest dist

.PHONY: tags
tags:
	rm -f tags
	ctags lib/*.c lib/*.h

TRACKFS = trackfs
trackinstall:
	$(TRACKFS) -l install.log -b backup.cpio $(MAKE) install

# For the justification of the following Makefile rules, see node
# `Automatic Remaking' in GNU Autoconf documentation.

$(MAINT)$(srcdir)/configure: $(srcdir)/configure.in $(srcdir)/aclocal.m4
	$(RM) $(srcdir)/configure
	cd $(srcdir) && autoconf

$(MAINT)$(srcdir)/config.h.in: $(srcdir)/stamp-h.in
$(MAINT)$(srcdir)/stamp-h.in: $(srcdir)/configure.in $(srcdir)/acconfig.h
	$(RM) $(srcdir)/config.h.in
	cd $(srcdir) && autoheader
	cd $(srcdir) && $(RM) stamp-h.in && echo timestamp > stamp-h.in

$(MAINT)config.h: stamp-h
$(MAINT)stamp-h: config.h.in config.status
	CONFIG_FILES= CONFIG_HEADERS=config.h ./config.status
	$(RM) stamp-h && echo timestamp > stamp-h

$(MAINT)Makefile: Makefile.in config.status
	CONFIG_FILES=$@ CONFIG_HEADERS= ./config.status

$(MAINT)lib/Makefile: lib/Makefile.in config.status
	CONFIG_FILES=$@ CONFIG_HEADERS= ./config.status

$(MAINT)lib/sys_elf.h: lib/stamp-h
$(MAINT)lib/stamp-h: lib/sys_elf.h.in config.status
	CONFIG_FILES= CONFIG_HEADERS=lib/sys_elf.h ./config.status
	$(RM) lib/stamp-h && echo timestamp > lib/stamp-h

$(MAINT)po/Makefile: po/Makefile.in config.status
	CONFIG_FILES=$@ CONFIG_HEADERS= ./config.status

$(MAINT)libelf.pc: libelf.pc.in config.status
	CONFIG_FILES=$@ CONFIG_HEADERS= ./config.status

RECHECK_FLAGS = CC='$(CC)' CPPFLAGS='$(CPPFLAGS)' \
	CFLAGS='$(CFLAGS)' LDFLAGS='$(LDFLAGS)' LIBS='$(LIBS)'

$(MAINT)config.status: configure config.h.in VERSION
	$(RECHECK_FLAGS) ./config.status --recheck

$(MAINT)reconfig:
	$(RM) config.cache
	$(RECHECK_FLAGS) ./config.status --recheck

# Tell versions [3.59,3.63) of GNU make not to export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
