# FrameNet

home
: http://deveiate.org/projects/FrameNet

code
: http://bitbucket.org/ged/FrameNet

github
: https://github.com/ged/framenet

docs
: http://deveiate.org/code/framenet


## Description

This is a Ruby interface to FrameNet, a lexical database of English word usage.

### Usage

You can look up frames either by name or by numeric ID:

    require 'frame_net'
    
    frame = FrameNet[ :Becoming_visible ]
    # => #<FrameNet::Frame:0x007fd84580cfd0 "Becoming_visible" [2582] 5 
		#      elements, 2 relations, 1 lexical units>

    FrameNet[ 2052 ]
    # => #<FrameNet::Frame:0x007fd84afc4a70 "Fear" [2052] 12 elements, 
		#      1 relations, 11 lexical units>



## Prerequisites

* Ruby


## Installation

    $ gem install ruby-framenet


## Contributing

You can check out the current development source with Mercurial via its
{project page}[http://bitbucket.org/ged/framenet]. Or if you prefer Git, via
{its Github mirror}[https://github.com/ged/framenet].

After checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the API documentation.


## License

This library includes data from the FrameNet project:

  https://framenet.icsi.berkeley.edu/

It is distributed under the terms of the Creative Commons Attribution
license:

  https://creativecommons.org/licenses/by/4.0/

Everything else:

Copyright (c) 2017, Michael Granger
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the author/s, nor the names of the project's
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


