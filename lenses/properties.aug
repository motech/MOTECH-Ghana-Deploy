(* Augeas module for editing java properties files
 Author: Craig Dunn <craig@craigdunn.org>
*)


module Properties =
	autoload xfm

	(* Define some basic primitives *)
	let indent		     = Util.indent
	let empty 	   	     = Util.empty
  	let eol 		     = Util.eol
    let comment          = Util.comment


	let sepch 		     = del /[ \t]*=[ \t]*/ "="
	let value_to_eol 	 = /[^ \t\n](.*[^ \t\n])?/
	let entry		     = /[A-Za-z_][A-Za-z0-9\._]+/

	(* define comments and properties*)
	let property	= [ indent . key entry . sepch . store value_to_eol . eol ]
	let empty_property = [ indent . key entry . sepch . store "" . del /\n/ "\n" ]

	(* setup our lens and filter*)
	let lns 		= ( property | empty_property | empty | comment  ) *
	let filter = incl "/tmp/test/test.properties"
			. Util.stdexcl

	let xfm	= transform lns filter



