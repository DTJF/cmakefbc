Welcome to package cmakefbc, an extension for the CMake build
management system to support the FreeBASIC (FB) programming language.
Find further information at the following links

- [about CMake](http://www.cmake.org), and

- [about FreeBASIC](http://www.freebasic.net)

The package includes

- CMake macros to extend the CMake system, and
  - checks for the FB compiler and its version,
  - tests the compiler,
  - declares internal CMake language variables (CMAKE_Fbc_...),
  - declares a macro to scan dependencies in FB source code, and
  - declares a function to pre-compile FB source to C source.

- the tool cmake_fb_deps.bas to scan dependency trees in FreeBASIC
  source code and integrate them in to a project.

Find the online documentation at
http://users.freebasic-portal.de/tjf/Projekte/cmakefbc/doc/html/.


Licence  {#SecLicence}
=======

Copyright (C) 2014-2015, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net

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
to: http://www.gnu.org/licenses/gpl-3.0.html
