#############################################################################
##
##  FakeLocalizeRing.gi                        LocalizeRingForHomalg package  
##
##  Copyright 2013, Mohamed Barakat, University of Kaiserslautern
##                  Vinay Wagh, Indian Institute of Technology Guwahati
##
##  Implementations of procedures for "fake" localized rings.
##
#############################################################################

DeclareRepresentation( "IsHomalgFakeLocalRingRep",
        IsHomalgRing
        and IsHomalgRingOrFinitelyPresentedModuleRep,
        [ "ring" ] );


DeclareRepresentation( "IsElementOfHomalgFakeLocalRingRep",
        IsHomalgRingElement,
        [ "pointer" ] );

DeclareRepresentation( "IsMatrixOverHomalgFakeLocalRingRep",
        IsHomalgMatrix,
        [ ] );

BindGlobal( "TheTypeHomalgFakeLocalRing",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgFakeLocalRingRep ) );

BindGlobal( "TheTypeElementOfHomalgFakeLocalRing",
        NewType( TheFamilyOfHomalgRingElements,
                IsElementOfHomalgFakeLocalRingRep ) );

BindGlobal( "TheTypeMatrixOverHomalgFakeLocalRing",
        NewType( TheFamilyOfHomalgMatrices,
                IsMatrixOverHomalgFakeLocalRingRep ) );

####################################
#
# methods for operations:
#
####################################

InstallMethod( AssociatedComputationRing,
        "for homalg fake local rings",
        [ IsHomalgFakeLocalRingRep ],
        
  function( R )
    
    if IsBound( R!.AssociatedComputationRing ) then
    
      return R!.AssociatedComputationRing;
    
    else
    
      return R!.ring;
    
    fi;
    
end );

InstallMethod( AssociatedComputationRing,
        "for homalg fake local ring elements",
        [ IsElementOfHomalgFakeLocalRingRep ],
        
  function( r )
    
    return AssociatedComputationRing( HomalgRing( r ) );
    
end );

InstallMethod( AssociatedComputationRing,
        "for matrices over homalg fake local rings",
        [ IsMatrixOverHomalgFakeLocalRingRep ],
        
  function( A )
    
    return AssociatedComputationRing( HomalgRing(A) );
    
end );

InstallMethod( AssociatedGlobalRing,
        "for homalg fake local rings",
        [ IsHomalgFakeLocalRingRep ],
        
  function( R )
    
    if IsBound( R!.AssociatedGlobalRing ) then
    
      return R!.AssociatedGlobalRing;
    
    else
    
      return R!.ring;
    
    fi;
    
end );

InstallMethod( AssociatedGlobalRing,
        "for homalg fake local ring elements",
        [ IsElementOfHomalgFakeLocalRingRep ],
        
  function( r )
    
    return AssociatedGlobalRing( HomalgRing( r ) );
    
end );

InstallMethod( AssociatedGlobalRing,
        "for homalg fake local matrices",
        [ IsMatrixOverHomalgFakeLocalRingRep ],
        
  function( A )
    
    return AssociatedGlobalRing( HomalgRing(A) );
    
end );

InstallMethod( Denominator,
        "for homalg fake local matrices",
        [ IsElementOfHomalgFakeLocalRingRep ],

  function( p )
    local R, quotR, globalR, numer, A, B;
    
    R := HomalgRing( p );
    quotR := AssociatedComputationRing( R );
    globalR := AssociatedGlobalRing( R );
    
    numer := Numerator( p );
    
    B := quotR * HomalgMatrix( [ numer ], 1, 1, globalR );
    A := HomalgMatrix( [ EvalRingElement( p ) ], 1, 1,  quotR );
    
    return MatElm( RightDivide( B, A ), 1, 1 ) / globalR ;
    
end );

InstallMethod( Numerator,
        "for homalg fake local matrices",
        [ IsElementOfHomalgFakeLocalRingRep ],
        
  function( p )
    local R, RP;
    
    R := HomalgRing( p );
    RP := homalgTable( R );
    
    if not IsBound(RP!.NumeratorOfPolynomial) then
        Error( "Table entry for NumeratorOfPolynomial not found\n" );
    fi;
 
    return HomalgRingElement( RP!.NumeratorOfPolynomial( p ), AssociatedComputationRing( R ) ) / AssociatedGlobalRing( R );
    
end );



# InstallMethod( Numerator,
#         "for homalg fake local ring elements",
#         [ IsElementOfHomalgFakeLocalRingRep ],
        
#   function( r )
    
#     local R, RP, uu;
    
#     if IsBound( r!.numer ) then
#         return r!.numer;
#     fi;
    
#     R := HomalgRing( r );
#     RP := homalgTable( R );
    
    
                     
#     if not IsBound(RP!.Numerator) then
#         Error( "Table entry for Numerator not found\n" );
#     fi;
    
# #    uu := RP!.Numerator( r ) / AssociatedGlobalRing( R );
#     uu := HomalgRingElement( RP!.Numerator( r ), AssociatedComputationRing( R ) ) / AssociatedGlobalRing( R );
#     r!.numer := uu;
    
#     return r!.numer;
    
# end );

#####################
InstallMethod( Numerator,
        "for homalg fake local matrices",
        [ IsMatrixOverHomalgFakeLocalRingRep ],
        
  function( M )
    
    return Eval( M )[1];
    
end );

#####################
InstallMethod( Name,
        "for homalg fake local ring elements",
        [ IsElementOfHomalgFakeLocalRingRep ],

  function( o )
    local name;
    
    if IsHomalgInternalRingRep( AssociatedComputationRing( o ) ) then
      name := String;
    else
      name := Name;
    fi;

    return name( EvalRingElement( o ) );
    
end );

InstallMethod( String,
        "for homalg fake local ring elements",
        [ IsElementOfHomalgFakeLocalRingRep ],

  function( o )
    
    return Name( o );
    
end );


##
InstallMethod( BlindlyCopyMatrixPropertiesToFakeLocalMatrix,	## under construction
        "for homalg matrices",
        [ IsHomalgMatrix, IsMatrixOverHomalgFakeLocalRingRep ],
        
  function( S, T )
    local c;
    
    for c in [ NrRows, NrColumns ] do
        if Tester( c )( S ) then
            Setter( c )( T, c( S ) );
        fi;
    od;
    
    for c in [ IsZero, IsOne, IsDiagonalMatrix ] do
        if Tester( c )( S ) and c( S ) then
            Setter( c )( T, c( S ) );
        fi;
    od;
    
end );
  

InstallMethod( SetMatElm,
        "for homalg local matrices",
        [ IsMatrixOverHomalgFakeLocalRingRep and IsMutable, IsPosInt, IsPosInt, IsElementOfHomalgFakeLocalRingRep, IsHomalgFakeLocalRingRep ],
        
  function( M, r, c, s, R )
    local cR, N, m, e;
    
    cR := AssociatedComputationRing( R );
    
    m := Eval( M );
    
    SetMatElm( m, r, c, EvalRingElement( s ) );

    M!.Eval := m;
    
end );

InstallMethod( AddToMatElm,
        "for homalg local matrices",
        [ IsMatrixOverHomalgFakeLocalRingRep and IsMutable, IsPosInt, IsPosInt, IsElementOfHomalgFakeLocalRingRep, IsHomalgFakeLocalRingRep ],
        
  function( M, r, c, s, R )
    local N, e;
    
    #create a matrix with just one entry (i,j), which is s
    N := HomalgInitialMatrix( NrRows( M ), NrColumns( M ), AssociatedComputationRing( R ) );
    SetMatElm( N, r, c, EvalRingElement( s ) );
    ResetFilterObj( N, IsInitialIdentityMatrix );
    
    #and add this matrix to M
    e := Eval( M + N );
    SetIsMutableMatrix( e[1], true );
    M!.Eval := e;
    
end );

InstallMethod( MatElmAsString,
        "for homalg fake local matrices",
        [ IsMatrixOverHomalgFakeLocalRingRep, IsPosInt, IsPosInt, IsHomalgFakeLocalRingRep ],
        
  function( M, r, c, R )
    local m;
    
    m := Eval( M );
    return  MatElmAsString( m, r, c, AssociatedComputationRing( R ) );
    
end );

InstallMethod( MatElm,
        "for matrices over homalg fake local ring",
        [ IsMatrixOverHomalgFakeLocalRingRep, IsPosInt, IsPosInt, IsHomalgFakeLocalRingRep ],
        
  function( M, r, c, R )
    local m;
    
    m := Eval( M );
    return ElementOfHomalgFakeLocalRing( MatElm( m, r, c, AssociatedComputationRing( R ) ), R );
    
end );

InstallMethod( Cancel,
        "for pairs of ring elements from the computation ring",
        [ IsRingElement, IsRingElement ],
        
  function( a, b )
    local za, zb, z, ma, mb, o, g;
    
    za := IsZero( a );
    zb := IsZero( b );
    
    if za and zb then
        
        z := Zero( a );
        
        return [ z, z ];
        
    elif za then
        
        return [ Zero( a ), One( a ) ];
        
    elif zb then
        
        return [ One( a ), Zero( a ) ];
        
    fi;
    
    if IsOne( a ) then
        
        return [ One( a ), b ];
        
    elif IsOne( b ) then
        
        return [ a, One( a ) ];
        
    fi;
    
    ma := a = -One( a );
    mb := b = -One( b );
    
    if ma and mb then
        
        o := One( a );
        
        return [ o, o ];
        
    elif ma then
        
        return [ One( a ), -b ];
        
    elif mb then
        
        return [ -a, One( b ) ];
        
    fi;
    
    g := Gcd( a, b );
    
    return [ a / g, b / g ];
    
end );

InstallMethod( Cancel,
        "for pairs of ring elements from the computation ring",
        [ IsHomalgRingElement, IsHomalgRingElement ],
        
  function( a, b )
    local R, za, zb, z, ma, mb, o, RP, result;
    
    R := HomalgRing( a );
    
    if R = fail then
        TryNextMethod( );
    elif not HasRingElementConstructor( R ) then
        Error( "no ring element constructor found in the ring\n" );
    fi;
    
    za := IsZero( a );
    zb := IsZero( b );
    
    if za and zb then
        
        z := Zero( R );
        
        return [ z, z ];
        
    elif za then
        
        return [ Zero( R ), One( R ) ];
        
    elif zb then
        
        return [ One( R ), Zero( R ) ];
        
    fi;
    
    if IsOne( a ) then
        
        return [ One( R ), b ];
        
    elif IsOne( b ) then
        
        return [ a, One( R ) ];
        
    fi;
    
    ma := IsMinusOne( a );
    mb := IsMinusOne( b );
    
    if ma and mb then
        
        o := One( R );
        
        return [ o, o ];
        
    elif ma then
        
        return [ One( R ), -b ];
        
    elif mb then
        
        return [ -a, One( R ) ];
        
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.CancelGcd) then
        
        result := RP!.CancelGcd( a, b );
        
        result := List( result, x -> HomalgRingElement( x, R ) );
        
        Assert( 6, result[1] * b = result[2] * a );
        
        return result;
        
    else	#fallback: no cancelation
        
        return [ a, b ];
        
    fi;
    
end );

##
InstallMethod( Cancel,
        "for pairs of global ring elements",
        [ IsRingElement and IsMinusOne, IsRingElement ],
        
  function( a, b )
    
    return [ One( b ), -b ];
    
end );

##
InstallMethod( Cancel,
        "for pairs of global ring elements",
        [ IsRingElement, IsRingElement and IsMinusOne ],
        
  function( a, b )
    
    return [ -a, One( a ) ];
    
end );

##
InstallMethod( Cancel,
        "for pairs of global ring elements",
        [ IsRingElement and IsMinusOne, IsRingElement and IsMinusOne ],
        
  function( a, b )
    local o;
    
    o := One( a );
    
    return [ o, o ];
    
end );

##
InstallMethod( Cancel,
        "for pairs of global ring elements",
        [ IsRingElement and IsOne, IsRingElement ],
        
  function( a, b )
    
    return [ One( a ), b ];
    
end );

##
InstallMethod( Cancel,
        "for pairs of global ring elements",
        [ IsRingElement, IsRingElement and IsOne ],
        
  function( a, b )
    
    return [ a, One( b ) ];
    
end );

##
InstallMethod( Cancel,
        "for pairs of global ring elements",
        [ IsRingElement and IsZero, IsRingElement ],
        
  function( a, b )
    
    return [ Zero( a ), One( a ) ];
    
end );

##
InstallMethod( Cancel,
        "for pairs of global ring elements",
        [ IsRingElement, IsRingElement and IsZero ],
        
  function( a, b )
    
    return [ One( b ), Zero( b ) ];
    
end );

##
InstallMethod( Cancel,
        "for pairs of global ring elements",
        [ IsRingElement and IsZero, IsRingElement and IsZero ],
        
  function( a, b )
    local z;
    
    z := Zero( a );
    
    return [ z, z ];
    
end );

##
InstallMethod( SaveHomalgMatrixToFile,
        "for fake local rings",
        [ IsString, IsHomalgMatrix, IsHomalgFakeLocalRingRep ],
        
  function( filename, M, R )
    local ComputationRing, MatStr;
    
    if LoadPackage( "HomalgToCAS" ) <> true then
       Error( "the package HomalgToCAS failed to load\n" );
    fi;
    
    MatStr := Concatenation( filename, "_matrix" );
    
    ComputationRing := AssociatedComputationRing( M );
    SaveHomalgMatrixToFile( MatStr, Eval( M ), ComputationRing );
    
    return MatStr;
    
end );

##
InstallMethod( LoadHomalgMatrixFromFile,
        "for fake local rings",
        [ IsString, IsInt, IsInt, IsHomalgFakeLocalRingRep ],
        
  function( filename, r, c, R )
    local ComputationRing, numer, denom, homalgIO;
    
    ComputationRing := AssociatedComputationRing( R );
    
    if IsExistingFile( Concatenation( filename, "_numerator" ) ) and IsExistingFile( Concatenation( filename, "_denominator" ) ) then
    
      numer := LoadHomalgMatrixFromFile( Concatenation( filename, "_numerator" ), r, c, ComputationRing );
      denom := LoadHomalgMatrixFromFile( Concatenation( filename, "_denominator" ), r, c, ComputationRing );
      denom := MatElm( denom, 1, 1 );
    
    elif IsExistingFile( filename ) then
    
      numer := LoadHomalgMatrixFromFile( filename, r, c, ComputationRing );
      denom := One( ComputationRing );
    
    else
    
      Error( "file does not exist" );
    
    fi;
    
    return MatrixOverHomalgFakeLocalRing( numer, denom, R );
    
end );

##
InstallMethod( CreateHomalgMatrixFromString,
        "constructor for homalg matrices over fake local rings",
        [ IsString, IsInt, IsInt, IsHomalgFakeLocalRingRep ],
        
  function( s, r, c, R )
    local mat;
    
    mat := CreateHomalgMatrixFromString( s, r, c, AssociatedComputationRing( R ) );
    
    return R * mat;
    
end );

#####################
InstallMethod( SetRingProperties,
        "for homalg fake local rings",
        [ IsHomalgRing ],
        
  function( S )
    local R;
    
    R := S!.AssociatedGlobalRing;
    
#    SetCoefficientsRing( S, R );
#    SetCharacteristic( S, Characteristic( R ) );
    
    if HasIsCommutative( R ) and IsCommutative( R ) then
        SetIsCommutative( S, true );
    fi;
    
#    if HasGlobalDimension( R ) then
#        SetGlobalDimension( S, GlobalDimension( R ) );	## would be wrong
#    fi;
#    if HasKrullDimension( R ) then
#        SetKrullDimension( S, KrullDimension( R ) ); ## would be wrong
#    fi;
#    
#    SetIsIntegralDomain( S, true ); ## would be wrong, see Hartshorne
    
    if HasCoefficientsRing( R ) then
        SetCoefficientsRing( S, CoefficientsRing( R ) );
    fi;
    
    if HasIndeterminatesOfPolynomialRing( R ) then
        SetIndeterminatesOfPolynomialRing( S,
                List( IndeterminatesOfPolynomialRing( R ),
                      x -> x / S )
                );
    fi;
    
    if HasIsFreePolynomialRing( R ) and IsFreePolynomialRing( R ) then
        SetIsIntegralDomain( S, true );
    fi;
    
    if HasKrullDimension( R ) and HasIsIntegralDomain( R ) and IsIntegralDomain( R ) then
        SetKrullDimension( S, KrullDimension( R ) );
    fi;
    
#    SetBasisAlgorithmRespectsPrincipalIdeals( S, true ); ## ???
    
end );

####################################
#
# constructor functions and methods:
#
####################################

## 
InstallMethod( LocalizeAtPrime,
        "constructor for homalg localized rings",
#        [ IsHomalgRing and IsCommutative, IsList, IsFinitelyPresentedSubmoduleRep and ConstructedAsAnIdeal and IsPrimeIdeal ],
        [ IsHomalgRing and IsCommutative, IsList, IsList ],
        
  function( globalR, X, p )
    local indets, Y, quotR, RP, localR, n_gens, gens;
    
    if IsEmpty( X ) then
        Error( "The list of variables should be non-empty\n" );
    fi;
    
    indets := Indeterminates( globalR );
    if not IsSubset( indets, X ) then
        Error( "The second argument should be a subset of the list of indeterminates of the ring\n" );
    fi;
    
#    Y := Difference( indets, X );
    Y := Filtered( indets, a -> not a in X );

    
    quotR := AddRationalParameters( CoefficientsRing( globalR ), X ) * Y;
    
    RP := CreateHomalgTableForLocalizedRingsAtPrimeIdeals( quotR );
    
    if not LoadPackage( "RingsForHomalg" ) = true then
        Error( "the package RingsForHomalg failed to load\n" );
    fi;
    
    if ValueGlobal( "IsHomalgExternalRingInSingularRep" )( globalR ) then
        
        UpdateMacrosOfLaunchedCAS( FakeLocalizeRingMacrosForSingular, homalgStream( globalR ) );
        AppendToAhomalgTable( RP, CommonHomalgTableForHomalgFakeLocalRing );
        
    fi;
    
    ## create the local ring
    localR := CreateHomalgRing( globalR, [ TheTypeHomalgFakeLocalRing, TheTypeMatrixOverHomalgFakeLocalRing ], ElementOfHomalgFakeLocalRing, RP );
    
    if not IsString( p ) then
        p := List( p,
                   function( x )
                       if not IsString( x ) then
                           return String( x );
                       fi;
                       return x;
                   end );
                          
        p := JoinStringsWithSeparator( p );
    fi;
    
    p := ParseListOfIndeterminates( SplitString( p, "," ) );
    
    if ForAny( p, IsString ) then
        p :=
          List( p,
                function( x )
                  if IsString( x ) then
                      return x / globalR;
                  fi;
                  return x;
              end );
              
    fi;
    
    SetConstructorForHomalgMatrices( localR,
            function( arg )
              local R, r, ar, M;
              
              R := arg[Length( arg )];
              
              #at least be able to construct 1x1-matrices from lists of ring elements for the fallback IsUnit
              if IsList( arg[1] ) and Length( arg[1] ) = 1 and IsHomalgLocalRingElementRep( arg[1][1] ) then
              
                r := arg[1][1];
              
                return HomalgLocalMatrix( HomalgMatrix( [ Numerator( r ) ], 1, 1, AssociatedComputationRing( R ) ), Denominator( r ), R );
              
              fi;
              
              ar := List( arg,
                          function( i )
                            if IsHomalgLocalRingRep( i ) then
                                return AssociatedComputationRing( i );
                            else
                                return i;
                            fi;
                          end );
              
              M := CallFuncList( HomalgMatrix, ar );
              
              return HomalgLocalMatrix( M, R );
              
            end );
    
    ## for the view methods:
    ## <A homalg fake local ring>
    ## <A matrix over a fake local ring>
    localR!.description := Concatenation( " fake local ring localized at <", String( p ), ">" );
    
    #Set the ideal, at which we localize
    n_gens := Length( p );
    gens := HomalgMatrix( p, n_gens, 1, globalR );
    SetGeneratorsOfPrimeIdeal( localR, gens );
    
    SetIndeterminatesOfPolynomialRing( localR, List( Indeterminates( quotR ), a -> a / localR ) );
    
    localR!.AssociatedGlobalRing := globalR;
    localR!.AssociatedComputationRing := quotR;
    
    SetRingProperties( localR );
    
    Perform( X, function( u ) u!.IsUnit := true; end );
    return localR;
    
end );

InstallGlobalFunction( ElementOfHomalgFakeLocalRing,
  function( arg )
    local nargs, elm, ring, ar, properties, denom, computationring, r;
    
    nargs := Length( arg );
    
    if nargs = 0 then
        Error( "empty input\n" );
    fi;
    
    elm := arg[1];
    
    if IsElementOfHomalgFakeLocalRingRep( elm ) then
        
        ##a local ring element as first argument will just be returned
        return elm;
        
    fi;
    
    properties := [ ];
    
    for ar in arg{[ 2 .. nargs ]} do
        if not IsBound( ring ) and IsHomalgRing( ar ) then
            ring := ar;
        elif IsList( ar ) and ForAll( ar, IsFilter ) then
            Append( properties, ar );
        else
            Error( "this argument (now assigned to ar) should be in { IsHomalgRing, IsList( IsFilter ), IsString }\n" );
        fi;
    od;
    
    computationring := AssociatedComputationRing( ring );
    
    if not IsHomalgRingElement( elm ) then
        elm := HomalgRingElement( elm, computationring );
    fi;
    
    if IsBound( ring ) then
        r := rec( ring := ring );
        ## Objectify:
        ObjectifyWithAttributes( r, TheTypeElementOfHomalgFakeLocalRing, EvalRingElement, elm );
#        ObjectifyWithAttributes( r, TheTypeElementOfHomalgFakeLocalRing, ring, ring );
#        Objectify( TheTypeElementOfHomalgFakeLocalRing, elm );
    fi;
    
    if properties <> [ ] then
        for ar in properties do
            Setter( ar )( r, true );
        od;
    fi;
    
    return r;
    
end );

##
InstallMethod( \/,
        "for homalg ring elements",
        [ IsRingElement, IsElementOfHomalgFakeLocalRingRep ],
        
  function( a, u )
    local R, RP, au;
    
    R := HomalgRing( u );
    
    if not IsHomalgRingElement( a ) then
        a := a / R;
    fi;
    
    if not HasRingElementConstructor( R ) then
        Error( "no ring element constructor found in the ring\n" );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.DivideByUnit) then
        if not IsUnit( u ) then
            return fail;
        fi;
        au := RP!.DivideByUnit( a, u );
        if au = fail then
            return fail;
        fi;
        return RingElementConstructor( R )( au, R );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( \/,
        "for homalg ring elements",
        [ IsElementOfHomalgFakeLocalRingRep, IsElementOfHomalgFakeLocalRingRep ],
        
  function( a, u )
    local R, RP, au;
    
    R := HomalgRing( u );
    
    if not HasRingElementConstructor( R ) then
        Error( "no ring element constructor found in the ring\n" );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.DivideByUnit) then
        if not IsUnit( u ) then
            return fail;
        fi;
        au := RP!.DivideByUnit( a, u );
        if au = fail then
            return fail;
        fi;
        return RingElementConstructor( R )( au, R );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( MatrixOverHomalgFakeLocalRing,
        "constructor for matrices over fake local rings",
        [ IsHomalgMatrix, IsHomalgFakeLocalRingRep ],
        
  function( A, R )
    local G, type, matrix, HookDenom, ComputationRing, rr, AA;
    
    G := HomalgRing( A );
    
    ComputationRing := AssociatedComputationRing( R );
    
    if not IsIdenticalObj( ComputationRing , HomalgRing( A ) ) then
      AA := ComputationRing * A;
    else
      AA := A;
    fi;
    
    matrix := rec( ring := R );
    
    ObjectifyWithAttributes(
        matrix, TheTypeMatrixOverHomalgFakeLocalRing,
        Eval, AA
    );
    
    BlindlyCopyMatrixPropertiesToFakeLocalMatrix( A, matrix );
    
    return matrix;
    
end );

##
InstallMethod( \*,
        "for homalg matrices",
        [ IsHomalgFakeLocalRingRep, IsHomalgMatrix ],
        
  function( R, m )
    
    if IsMatrixOverHomalgFakeLocalRingRep( m ) then
        TryNextMethod( );
    fi;
    
    return MatrixOverHomalgFakeLocalRing( AssociatedComputationRing( R ) * m, R );
    
end );

##
InstallMethod( \*,
        "for matrices over fake local rings",
        [ IsHomalgRing, IsMatrixOverHomalgFakeLocalRingRep ],
        
  function( R, m )
    
    return R * Eval( m );
    
end );

##
InstallMethod( PostMakeImmutable,
        "for matrices over homalg fake local rings ",
        [ IsMatrixOverHomalgFakeLocalRingRep and HasEval ],
        
  function( A )
    
    MakeImmutable( Eval( A ) );
    
end );

##
InstallMethod( SetIsMutableMatrix,
        "for matrices over homalg fake local rings ",
        [ IsMatrixOverHomalgFakeLocalRingRep, IsBool ],
        
  function( A, b )
    
    if b = true then
      SetFilterObj( A, IsMutable );
    else
      ResetFilterObj( A, IsMutable );
    fi;
    
    SetIsMutableMatrix( Eval( A ), b );
    
end );

##
InstallMethod( RingOfDerivations,
        "for fake local rings",
        [ IsHomalgFakeLocalRingRep ],
        
  function( Rm )
    local R;
    
    R := AssociatedGlobalRing( Rm );
    
    return RingOfDerivations( R );
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( Display,
        "for homalg fake local ring elements",
        [ IsElementOfHomalgFakeLocalRingRep ],
        
  function( r )
    
    Print( Name( r ), "\n" );
    
end );

##
InstallMethod( Display,
        "for homalg matrices over a homalg fake local ring",
        [ IsMatrixOverHomalgFakeLocalRingRep ],
        
  function( A )
    
    Display( Eval( A ) );
    
end );