classdef doc_testing < handle & my.super.Class
    % General 'idea' about Class's functionality.
   
    properties (SetAccess = private)    
        spectra % A struct carrying the eigenvalues and eigenvectors of the basis. 
    end
    
    methods
        function h = doc_testing(x)
        % Set stuff
        %
		% Parameters
		% ----------
        % x : int 
		%	The path of the file to wrap
		%
		% Returns
		% -------
		% h : :class:`~doc_test.doc_testing`
		%	Instance of doc_testing initialized with x
            h.x = x
        end
        
        function x = get_x(obj)
        % Get stuff
		%
		% Returns
		% -------
		% x : int
		%	Useless output
            x = obj.x
        end
    end
    
    methods (Static)
        function [w,x] = my_static_function(z)

        % A static function in 
		%
		% ilugzidfmi
        %
        % Parameters
		% ----------
        % z : int 
		%	The path of the file to wrap
		%
		% Returns
		% -------
        % w : Laplace_Beltrami
		%	A buffered writable file descriptor
		% x : int
		%	Another useless output

            w = z
        end
		
		function w = my_other_static_function(z)

        % A static function in 
        %
        % :param z: input z : int
        % :returns: w : (Laplace_Beltrami) A buffered writable file descriptor

            w = z
        end
    end
end