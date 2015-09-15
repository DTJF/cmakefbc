Welcome to project cmakefbc, an extension for the CMake build
management system to support the FreeBASIC (FB) programming language.
Find further information on that components at the following links

- [about CMake](http://www.cmake.org), and

- [about FreeBASIC](http://www.freebasic.net)

The package is [hosted at GitHub](https://github.com/DTJF/cmakefbc) and
it includes

- CMake macros to extend the CMake system, in order to
  - check for the FB compiler and its version,
  - test the compiler,
  - declare internal CMake language variables (CMAKE_Fbc_...),
  - declare a macro to scan dependencies in FB source code, and
  - declare a function to pre-compile FB source to C source.

- the tool cmake_fb_deps.bas to
  - scan the dependency files in FreeBASIC source trees and
  - integrate them in to a projects build tree.

Find the online documentation at
http://users.freebasic-portal.de/tjf/Projekte/cmakefbc/doc/html/.


Licence
=======

GPLv3: Copyright (C) 2014-2015, Thomas{ doT ]Freiherr[ At ]gmx[ DoT }net

This bundle is free software; you can redistribute the sources and/or
modify them under the terms of the GNU General Public License version 3
as published by the Free Software Foundation.

The programs are distributed in the hope that they will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110- 1301, USA. Or refer
to http://www.gnu.org/licenses/gpl-3.0.html
