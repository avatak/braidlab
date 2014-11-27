function c = tensor(a,b)
%TENSOR   Tensor product of two braids.
%   C = TENSOR(A,B) returns the tensor product of the braids A and B, which
%   is the braid obtained by putting A and B side-by-side, with A on the
%   left.
%
%   This is a method for the BRAID class.
%   See also BRAID, BRAID.MTIMES.

% <LICENSE
%   Braidlab: a Matlab package for analyzing data using braids
%
%   http://github.com/jeanluct/braidlab
%
%   Copyright (C) 2013-2015  Jean-Luc Thiffeault <jeanluc@math.wisc.edu>
%                            Marko Budisic         <marko@math.wisc.edu>
%
%   This file is part of Braidlab.
%
%   Braidlab is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   Braidlab is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with Braidlab.  If not, see <http://www.gnu.org/licenses/>.
% LICENSE>

n1 = a.n;
n2 = b.n;

sg = sign(b.word);
idx = abs(b.word) + n1;  % re-index generators of b2

c = braidlab.braid([a.word idx.*sg],n1+n2);
