%LOOP   Class for representing topological loops in Dynnikov coordinates.
%   A LOOP object represents an equivalence class (under isotopy) of simple
%   closed loops on a disk with N punctures.  The representative loop is
%   encoded in Dynnikov coordinates.  We use the shorthand "loop" to refer
%   to the entire equivalence class.  The loops represented may be
%   multiloops (with disjoint, nonintersecting components), and each
%   component is essential (not contractible to the punctures or the
%   boundary).
%
%   The class LOOP has only one data member:
%
%    'coords'   vector of Dynnikov coordinates [a,b] of length 2N-4.
%
%   In addition, LOOP has the dependent properties
%
%    'n'        the number of punctures;
%    'a'        the 'a' vector of Dynnikov coordinates, of length N-2;
%    'b'        the 'b' vector of Dynnikov coordinates, of length N-2.
%
%   METHODS(LOOP) shows a list of methods.
%
%   References:
%
%   I. A. Dynnikov, "On a Yang-Baxter map and the Dehornoy ordering,"
%   Russian Mathematical Surveys 57 (2002), 592-594.
%
%   J.-O. Moussafir, "On Computing the Entropy of Braids," Functional
%   Analysis and Other Mathematics 1 (2006), 37-46.
%
%   T. Hall & S. Yurttas, "On the topological entropy of families of
%   braids," Topology and its Applications 156 (2009), 1554-1564.
%
%   J.-L. Thiffeault, "Braids of entangled particle trajectories," Chaos
%   20 (2010), 017516.
%
%   See also LOOP.LOOP (constructor), BRAID.

classdef loop
  properties
    coords = [0 -1]; % Dynnikov coordinates
  end
  properties (Dependent = true)
    n                % number of strings
    a                % "a" Dynnikov coord vector
    b                % "b" Dynnikov coord vector
  end

  methods

    function l = loop(c,b)
    %LOOP   Construct a loop object.
    %   L = LOOP(D) creates a loop object L from a vector of Dynnikov
    %   coordinates D.  D must have 2*N-4 elements, where N is the number of
    %   punctures.  Here, loop means a "topological loop", or more precisely
    %   an equivalence class of simple closed multicurves under isotopy.
    %
    %   L = LOOP(A,B) creates a loop object L from (A,B) vectors of Dynnikov
    %   coordinates, each of length N-2, where N is the number of punctures.
    %
    %   L = LOOP(N) where N is an integer (N>1) creates a loop object L with
    %   N+1 punctures.  The loop L is a (nonoriented) generating set for the
    %   fundamental group of the sphere with N punctures, with the extra
    %   puncture serving as the basepoint.  This sort of object is
    %   convenient when looking for growth of loops under braid action, or
    %   for testing for braid equality.
    %
    %   This is a method for the LOOP class.
    %   See also LOOP, BRAID, BRAID.LOOPCOORDS, BRAID.EQ.

      % Default loop around first two of three punctures.
      if nargin == 0, return; end
      if isscalar(c) & ~isa(c,'braidlab.loop')
	% Nested generators of the fundamental group of a sphere with c
        % punctures with an extra basepoint puncture on the right.
	if c < 2
	  error('BRAIDLAB:loop:loop', ...
		'Need at least two punctures.');
	end
	n1 = c-1;
	l.coords = zeros(1,2*n1);
	l.coords(n1+1:end) = -1;
	return
      end
      if isa(c,'braidlab.loop')
	l.coords = c.coords;
	return
      end
      if nargin == 1
	% Create from a single vector of even length.
	if mod(length(c),2) == 1
	  error('BRAIDLAB:loop:loop', ...
		'Loop coordinate vector must have even length.')
	end
	l.coords = c;
      else
	% Create a,b separately from two vectors of the same length.
	if length(c) ~= length(b)
	  error('BRAIDLAB:loop:loop', ...
		'Loop coordinate vectors must have the same length.')
	end
	n1 = length(c);
	l.coords = zeros(1,2*n1);
	l.coords(1:n1) = c;
	l.coords(n1+1:end) = b;
      end
    end

    % Use this to add a puncture?
    %function obj = set.n(obj,value)
    %end

    function value = get.n(obj)
      % Length of coords is 2n-4, where n is the number of punctures.
      value = length(obj.coords)/2 + 2;
    end

    function value = get.a(obj)
      value = obj.coords(1:length(obj.coords)/2);
    end

    function value = get.b(obj)
      value = obj.coords(length(obj.coords)/2+1:end);
    end

    function [a,b] = ab(obj)
    %AB   Return the A and B vectors of Dynnikov coordinates.
    %   [A,B] = AB(L) returns the A and B Dynnikov coordinate vectors of
    %   a loop L.
    %
    %   This is a method for the LOOP class.
    %   See also LOOP.
      a = obj.a; b = obj.b;
    end

    function ee = eq(l1,l2)
    %EQ   Test loops for equality.
    %
    %   This is a method for the LOOP class.
    %   See also LOOP, BRAID.EQ.
      ee = l1.n == l2.n;
      if ee, ee = all(l1.coords == l2.coords); end
    end

    function ee = ne(l1,l2)
    %NE   Test loops for inequality.
    %
    %   This is a method for the LOOP class.
    %   See also LOOP, LOOP.EQ.
      ee = ~(l1 == l2);
    end

    function str = char(obj)
    %CHAR   Convert loop to string.
    %
    %   This is a method for the LOOP class.
    %   See also LOOP, LOOP.DISP.
      str = ['(( ' num2str(obj.coords) ' ))'];
    end

    function disp(obj)
    %DISP   Display a loop.
    %
    %   This is a method for the LOOP class.
    %   See also LOOP, LOOP.DISP.
       c = char(obj);
       if iscell(c)
	 disp(['     ' c{:}])
       else
	 disp(c)
       end
    end

    function l = length(obj)
    %LENGTH   The minimum length of a loop.
    %   LEN = LENGTH(L) computes the minimum length of a loop, assuming
    %   the loop has zero thickness, and the punctures have zero size and
    %   are one unit apart.
    %
    %   This is a method for the LOOP class.
    %   See also LOOP, LOOP.INTAXIS.
      [~,nu] = obj.intersec;
      l = sum(nu);
    end

    function l = intaxis(obj)
    %INTAXIS   The number of intersections of a loop with the real axis.
    %   I = INTAXIS(L) computes the minimum number of intersections of a
    %   loop L with the real axis.
    %
    %   This is a method for the LOOP class.
    %   See also LOOP, LOOP.LENGTH.
      [a,b] = obj.ab;

      % The number of intersections before/after the first and last punctures.
      % See Hall & Yurttas (2009).
      cumb = [0 cumsum(b,2)];
      b0 = -max(abs(a) + max(b,0) + cumb(1:end-1));
      bn1 = -b0 - sum(b);

      % The number of intersections with the real axis.
      l = sum(abs(b)) + sum(abs(a(2:end)-a(1:end-1))) ...
	  + abs(a(1)) + abs(a(end)) + abs(b0) + abs(bn1);
    end

  end % methods block

end % loop classdef
