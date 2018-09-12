Changelog and Credits {#PagChangelog}
=====================
\tableofcontents


# Further Development {#SecFurtherVev}

\Proj is already a powerful tool to build FB projects with the \CMake
manager. But there's still some optimization potential, like:

- conditional #`INCLUDE` handling in cmakefbc_deps
- ...

Feel free to post your ideas, bug reports, wishes or patches, either
to the project page at

- \Webs

or to the

- [forum page](http://www.freebasic.net/forum/viewtopic.php?p=203093)

or feel free to send your ideas directly to the author (\Mail).


## cmakefbc-1.0 {#SecV-1-0-0}

- new: tool renamed fb-doc -> fbdoc
- new: file renamed UseFb-Doc.cmake -> UseFbDoc.cmake
- new: file renamed FindFb-Doc.cmake -> FindFbDoc.cmake
- new: help and version output for cmakefbc_deps tool
- new: path options for cmakefbc_deps tool (-h: headers, -i: src)
- new: output upload time for target doc_www in file UseFbDoc~doc_www~target~touch
- fix: CMAKE_Fbc_COMPILER_WORKS in cache (CMakeTestFbc.cmake)
- fix: Doxygen FILTER_[SOURCE_]PATTERN setting in UseFbDoc.cmake
- fix: no more (false) warnings on existant fbc headers in default path
- fix: target doc_www reference file renamed DocWWW.time -> UseFbDoc~doc_www~target~touch

Released on 2018 September.


## cmakefbc-0.6 {#SecV-0-6-0}

- new: folder debian for Debian package building (src, bin, doc)
- new: target deb to build Debian packages
- new: Unix target distclear (to build Debian packages)
- new: non-versioned install folder share/cmakefbc/Modules
- new: cmakefbc wrapper script to configure a build tree
- fix: timestamp for target doc_www
- fix: renamed cmake_fb_deps.bas --> cmakefbc_deps.bas
- fix: adapted documentation

Released on 2016 December, 26.


## cmakefbc-0.4.2 {#SecV-0-4-2}

- new: CMake script files for fb-doc: FindFb-Doc.cmake; UseFb-Doc.cmake
- new: doc page Files and Folders (+ minor fixes and improvements)
- new: documentational comments stripped in listing
- new: flag NO_SYNTAX in UseFb-Doc
- fix: ReadMe.md.in file replaces aliases by text (for GitHub start page)
- fix: file in folder Platform renamed (camel case -> consistent shema)
- fix: install CMAKE_MODULE_PATH issue fixed

Released on 2016 March, 16.


## cmakefbc-0.4 {#SecV-0-4}

- cmake_fb_deps.bas: Improved path handling
- cmake_fb_deps.bas: Warnings when #`INCLUDE` file not present (warns for each standard header)
- doxy/CMakeLists.txt: out-of-source build for documentation

Released on 2015 March, 16.


## cmakefbc-0.2 {#SecV-0-2}

- Compiler check reads implicit directories and libraries in variables CMAKE_Fbc_IMPLICIT_LINK_DIRECTORIES and CMAKE_Fbc_IMPLICIT_LINK_LIBRARIES.

- New directory structure allows easy includes in source packages.

- Optimzed compiler flags (bug regarding linked libraries with filespec. fixed).

Released on 2015 January, 15.


## cmakefbc-0.0 {#SecV-0-0}

Initial release on 2014 November, 30.



# Credits {#SecCredits}

Thanks go to:

- The FreeBASIC developer team for creating a great compiler.

- Bill Hoffman, Ken Martin, Brad King, Dave Cole, Alexander Neundorf,
  Clinton Stimpson for developing the \CMake tool and publishing it
  under an open licence (the documentation has optimization
  potential).

- Dimitri van Heesch for creating the \Doxygen tool, which is used to
  generate this documentation.

- Arend Lammertink for providing Debian packages for armhf architecture
  and hosting them on his server.

- All others I forgot to mention.
