# This is an automatically generated file by the R module for SWIG.

##   Generated via the command line invocation:
##	 swig -r -v -o pdq/src/pdq.c ../pdq.i


#                         srun.swg                            #
#
# This is the basic code that is needed at run time within R to
# provide and define the relevant classes.  It is included
# automatically in the generated code by copying the contents of
# srun.swg into the newly created binding code.


# This could be provided as a separate run-time library but this
# approach allows the code to to be included directly into the
# generated bindings and so removes the need to have and install an
# additional library.  We may however end up with multiple copies of
# this and some confusion at run-time as to which class to use. This
# is an issue when we use NAMESPACES as we may need to export certain
# classes.

######################################################################

if(length(getClassDef("RSWIGStruct")) == 0) 
  setClass("RSWIGStruct", representation("VIRTUAL"))



if(length(getClassDef("ExternalReference")) == 0) 
# Should be virtual but this means it loses its slots currently
#representation("VIRTUAL")
  setClass("ExternalReference", representation( ref = "externalptr"))



if(length(getClassDef("NativeRoutinePointer")) == 0) 
  setClass("NativeRoutinePointer", 
              representation(parameterTypes = "character",
                             returnType = "character",
                             "VIRTUAL"), 
              contains = "ExternalReference")

if(length(getClassDef("CRoutinePointer")) == 0) 
  setClass("CRoutinePointer", contains = "NativeRoutinePointer")


if(length(getClassDef("EnumerationValue")) == 0) 
  setClass("EnumerationValue", contains = "integer")


if(!isGeneric("copyToR")) 
 setGeneric("copyToR",
            function(value, obj = new(gsub("Ref$", "", class(value)))) 
               standardGeneric("copyToR"
           ))

setGeneric("delete", function(obj) standardGeneric("delete"))


SWIG_createNewRef = 
function(className, ..., append = TRUE)
{
  f = get(paste("new", className, sep = "_"), mode = "function")

  f(...)
}

if(!isGeneric("copyToC")) 
 setGeneric("copyToC", 
             function(value, obj = RSWIG_createNewRef(class(value)))
              standardGeneric("copyToC"
            ))


# 
defineEnumeration =
function(name, .values, where = topenv(parent.frame()), suffix = "Value")
{
   # Mirror the class definitions via the E analogous to .__C__
  defName = paste(".__E__", name, sep = "")
  assign(defName,  .values,  envir = where)

  if(nchar(suffix))
    name = paste(name, suffix, sep = "")

  setClass(name, contains = "EnumerationValue", where = where)
}

enumToInteger <- function(name,type)
{
   if (is.character(name)) {
   ans <- as.integer(get(paste(".__E__", type, sep = ""))[name])
   if (is.na(ans)) {warning("enum not found ", name, " ", type)}
   ans
   } 
}

enumFromInteger =
function(i,type)
{
  itemlist <- get(paste(".__E__", type, sep=""))
  names(itemlist)[match(i, itemlist)]
}

coerceIfNotSubclass =
function(obj, type) 
{
    if(!is(obj, type)) {as(obj, type)} else obj
}


setClass("SWIGArray", representation(dims = "integer"), contains = "ExternalReference")

setMethod("length", "SWIGArray", function(x) x@dims[1])


defineEnumeration("SCopyReferences",
                   .values = c( "FALSE" = 0, "TRUE" = 1, "DEEP" = 2))

assert = 
function(condition, message = "")
{
  if(!condition)
    stop(message)

  TRUE
}


if(FALSE) {
print.SWIGFunction =
function(x, ...)
 {
 }
}


#######################################################################

R_SWIG_getCallbackFunctionStack =
function()
{
    # No PACKAGE argument as we don't know what the DLL is.
  .Call("R_SWIG_debug_getCallbackFunctionData")
}

R_SWIG_addCallbackFunctionStack =
function(fun, userData = NULL)
{
    # No PACKAGE argument as we don't know what the DLL is.
  .Call("R_SWIG_R_pushCallbackFunctionData", fun, userData)
}


#######################################################################


setClass('_p_SYSTAT_TYPE', contains = 'ExternalReference')
setClass("SYSTAT_TYPE",
    representation(
        response = "numeric",
        thruput = "numeric",
        residency = "numeric",
        physmem = "numeric",
        highwater = "numeric",
        malloc = "numeric",
        mpl = "numeric",
        maxN = "numeric",
        maxTP = "numeric",
        minRT = "numeric"),
        contains = "RSWIGStruct")


# End class SYSTAT_TYPE

setClass('_p_TERMINAL_TYPE', contains = 'ExternalReference')
setClass("TERMINAL_TYPE",
    representation(
        name = "character",
        pop = "numeric",
        think = "numeric"),
        contains = "RSWIGStruct")


# End class TERMINAL_TYPE

setClass('_p_BATCH_TYPE', contains = 'ExternalReference')
setClass("BATCH_TYPE",
    representation(
        name = "character",
        pop = "numeric"),
        contains = "RSWIGStruct")


# End class BATCH_TYPE

setClass('_p_TRANSACTION_TYPE', contains = 'ExternalReference')
setClass("TRANSACTION_TYPE",
    representation(
        name = "character",
        arrival_rate = "numeric",
        saturation_rate = "numeric"),
        contains = "RSWIGStruct")


# End class TRANSACTION_TYPE

setClass('_p_JOB_TYPE', contains = 'ExternalReference')
setClass("JOB_TYPE",
    representation(
        should_be_class = "numeric",
        network = "numeric"),
        contains = "RSWIGStruct")


# End class JOB_TYPE

setClass('_p_NODE_TYPE', contains = 'ExternalReference')
setClass("NODE_TYPE",
    representation(
        devtype = "numeric",
        sched = "numeric",
        devname = "character",
        visits = "numeric",
        service = "numeric",
        demand = "numeric",
        resit = "numeric",
        utiliz = "numeric",
        qsize = "numeric",
        avqsize = "numeric"),
        contains = "RSWIGStruct")


# End class NODE_TYPE




setMethod('[', "ExternalReference",
function(x,i,j, ..., drop=TRUE) 
if (!is.null(x$"__getitem__")) 
sapply(i, function(n) x$"__getitem__"(i=as.integer(n-1))))

setMethod('[<-' , "ExternalReference",
function(x,i,j, ..., value) 
if (!is.null(x$"__setitem__")) {
sapply(1:length(i), function(n) 
x$"__setitem__"(i=as.integer(i[n]-1), x=value[n]))
x
})

setAs('ExternalReference', 'character',
function(from) {if (!is.null(from$"__str__")) from$"__str__"()})

setMethod('print', 'ExternalReference',
function(x) {print(as(x, "character"))})

# Start of version_set

`version_set` = function(s_version)
{
  s_version = as(s_version, "character") 
  .Call('R_swig_version_set', s_version, PACKAGE='pdq')
  
}

attr(`version_set`, 'returnType') = 'void'
attr(`version_set`, "inputTypes") = c('character')
class(`version_set`) = c("SWIGFunction", class('version_set'))

# Start of version_get

`version_get` = function()
{
  .Call('R_swig_version_get', PACKAGE='pdq')
  
}

attr(`version_get`, 'returnType') = 'character'
class(`version_get`) = c("SWIGFunction", class('version_get'))

version = 
function(value)
{
  if(missing(value)) {
    version_get()
  } else {
    version_set(value)
  }
}

# Start of SYSTAT_TYPE_response_set

`SYSTAT_TYPE_response_set` = function(self, s_response)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_response = as.numeric(s_response) 
  .Call('R_swig_SYSTAT_TYPE_response_set', self, s_response, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_response_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_response_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_response_set`) = c("SWIGFunction", class('SYSTAT_TYPE_response_set'))

# Start of SYSTAT_TYPE_response_get

`SYSTAT_TYPE_response_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_response_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_response_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_response_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_response_get`) = c("SWIGFunction", class('SYSTAT_TYPE_response_get'))

# Start of SYSTAT_TYPE_thruput_set

`SYSTAT_TYPE_thruput_set` = function(self, s_thruput)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_thruput = as.numeric(s_thruput) 
  .Call('R_swig_SYSTAT_TYPE_thruput_set', self, s_thruput, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_thruput_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_thruput_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_thruput_set`) = c("SWIGFunction", class('SYSTAT_TYPE_thruput_set'))

# Start of SYSTAT_TYPE_thruput_get

`SYSTAT_TYPE_thruput_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_thruput_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_thruput_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_thruput_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_thruput_get`) = c("SWIGFunction", class('SYSTAT_TYPE_thruput_get'))

# Start of SYSTAT_TYPE_residency_set

`SYSTAT_TYPE_residency_set` = function(self, s_residency)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_residency = as.numeric(s_residency) 
  .Call('R_swig_SYSTAT_TYPE_residency_set', self, s_residency, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_residency_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_residency_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_residency_set`) = c("SWIGFunction", class('SYSTAT_TYPE_residency_set'))

# Start of SYSTAT_TYPE_residency_get

`SYSTAT_TYPE_residency_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_residency_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_residency_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_residency_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_residency_get`) = c("SWIGFunction", class('SYSTAT_TYPE_residency_get'))

# Start of SYSTAT_TYPE_physmem_set

`SYSTAT_TYPE_physmem_set` = function(self, s_physmem)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_physmem = as.numeric(s_physmem) 
  .Call('R_swig_SYSTAT_TYPE_physmem_set', self, s_physmem, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_physmem_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_physmem_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_physmem_set`) = c("SWIGFunction", class('SYSTAT_TYPE_physmem_set'))

# Start of SYSTAT_TYPE_physmem_get

`SYSTAT_TYPE_physmem_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_physmem_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_physmem_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_physmem_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_physmem_get`) = c("SWIGFunction", class('SYSTAT_TYPE_physmem_get'))

# Start of SYSTAT_TYPE_highwater_set

`SYSTAT_TYPE_highwater_set` = function(self, s_highwater)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_highwater = as.numeric(s_highwater) 
  .Call('R_swig_SYSTAT_TYPE_highwater_set', self, s_highwater, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_highwater_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_highwater_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_highwater_set`) = c("SWIGFunction", class('SYSTAT_TYPE_highwater_set'))

# Start of SYSTAT_TYPE_highwater_get

`SYSTAT_TYPE_highwater_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_highwater_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_highwater_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_highwater_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_highwater_get`) = c("SWIGFunction", class('SYSTAT_TYPE_highwater_get'))

# Start of SYSTAT_TYPE_malloc_set

`SYSTAT_TYPE_malloc_set` = function(self, s_malloc)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_malloc = as.numeric(s_malloc) 
  .Call('R_swig_SYSTAT_TYPE_malloc_set', self, s_malloc, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_malloc_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_malloc_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_malloc_set`) = c("SWIGFunction", class('SYSTAT_TYPE_malloc_set'))

# Start of SYSTAT_TYPE_malloc_get

`SYSTAT_TYPE_malloc_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_malloc_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_malloc_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_malloc_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_malloc_get`) = c("SWIGFunction", class('SYSTAT_TYPE_malloc_get'))

# Start of SYSTAT_TYPE_mpl_set

`SYSTAT_TYPE_mpl_set` = function(self, s_mpl)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_mpl = as.numeric(s_mpl) 
  .Call('R_swig_SYSTAT_TYPE_mpl_set', self, s_mpl, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_mpl_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_mpl_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_mpl_set`) = c("SWIGFunction", class('SYSTAT_TYPE_mpl_set'))

# Start of SYSTAT_TYPE_mpl_get

`SYSTAT_TYPE_mpl_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_mpl_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_mpl_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_mpl_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_mpl_get`) = c("SWIGFunction", class('SYSTAT_TYPE_mpl_get'))

# Start of SYSTAT_TYPE_maxN_set

`SYSTAT_TYPE_maxN_set` = function(self, s_maxN)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_maxN = as.numeric(s_maxN) 
  .Call('R_swig_SYSTAT_TYPE_maxN_set', self, s_maxN, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_maxN_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_maxN_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_maxN_set`) = c("SWIGFunction", class('SYSTAT_TYPE_maxN_set'))

# Start of SYSTAT_TYPE_maxN_get

`SYSTAT_TYPE_maxN_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_maxN_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_maxN_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_maxN_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_maxN_get`) = c("SWIGFunction", class('SYSTAT_TYPE_maxN_get'))

# Start of SYSTAT_TYPE_maxTP_set

`SYSTAT_TYPE_maxTP_set` = function(self, s_maxTP)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_maxTP = as.numeric(s_maxTP) 
  .Call('R_swig_SYSTAT_TYPE_maxTP_set', self, s_maxTP, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_maxTP_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_maxTP_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_maxTP_set`) = c("SWIGFunction", class('SYSTAT_TYPE_maxTP_set'))

# Start of SYSTAT_TYPE_maxTP_get

`SYSTAT_TYPE_maxTP_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_maxTP_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_maxTP_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_maxTP_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_maxTP_get`) = c("SWIGFunction", class('SYSTAT_TYPE_maxTP_get'))

# Start of SYSTAT_TYPE_minRT_set

`SYSTAT_TYPE_minRT_set` = function(self, s_minRT)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  s_minRT = as.numeric(s_minRT) 
  .Call('R_swig_SYSTAT_TYPE_minRT_set', self, s_minRT, PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_minRT_set`, 'returnType') = 'void'
attr(`SYSTAT_TYPE_minRT_set`, "inputTypes") = c('_p_SYSTAT_TYPE', 'numeric')
class(`SYSTAT_TYPE_minRT_set`) = c("SWIGFunction", class('SYSTAT_TYPE_minRT_set'))

# Start of SYSTAT_TYPE_minRT_get

`SYSTAT_TYPE_minRT_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_SYSTAT_TYPE_minRT_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`SYSTAT_TYPE_minRT_get`, 'returnType') = 'numeric'
attr(`SYSTAT_TYPE_minRT_get`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`SYSTAT_TYPE_minRT_get`) = c("SWIGFunction", class('SYSTAT_TYPE_minRT_get'))

# Start of new_SYSTAT_TYPE

`SYSTAT_TYPE` = function()
{
  ans = .Call('R_swig_new_SYSTAT_TYPE', PACKAGE='pdq')
  class(ans) <- "_p_SYSTAT_TYPE"
  
  ans
  
}

attr(`SYSTAT_TYPE`, 'returnType') = '_p_SYSTAT_TYPE'
class(`SYSTAT_TYPE`) = c("SWIGFunction", class('SYSTAT_TYPE'))

# Start of delete_SYSTAT_TYPE

`delete_SYSTAT_TYPE` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_SYSTAT_TYPE") 
  .Call('R_swig_delete_SYSTAT_TYPE', self, PACKAGE='pdq')
  
}

attr(`delete_SYSTAT_TYPE`, 'returnType') = 'void'
attr(`delete_SYSTAT_TYPE`, "inputTypes") = c('_p_SYSTAT_TYPE')
class(`delete_SYSTAT_TYPE`) = c("SWIGFunction", class('delete_SYSTAT_TYPE'))

# Start of accessor method for SYSTAT_TYPE
setMethod('$', '_p_SYSTAT_TYPE', function(x, name)

{
  accessorFuns = list('response' = SYSTAT_TYPE_response_get, 'thruput' = SYSTAT_TYPE_thruput_get, 'residency' = SYSTAT_TYPE_residency_get, 'physmem' = SYSTAT_TYPE_physmem_get, 'highwater' = SYSTAT_TYPE_highwater_get, 'malloc' = SYSTAT_TYPE_malloc_get, 'mpl' = SYSTAT_TYPE_mpl_get, 'maxN' = SYSTAT_TYPE_maxN_get, 'maxTP' = SYSTAT_TYPE_maxTP_get, 'minRT' = SYSTAT_TYPE_minRT_get)
  vaccessors = c('response', 'thruput', 'residency', 'physmem', 'highwater', 'malloc', 'mpl', 'maxN', 'maxTP', 'minRT')
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name))
  f = accessorFuns[[idx]]
  formals(f)[[1]] = x
  if (is.na(match(name, vaccessors))) f else f(x)
}


)
# end of accessor method for SYSTAT_TYPE
# Start of accessor method for SYSTAT_TYPE
setMethod('$<-', '_p_SYSTAT_TYPE', function(x, name, value)

{
  accessorFuns = list('response' = SYSTAT_TYPE_response_set, 'thruput' = SYSTAT_TYPE_thruput_set, 'residency' = SYSTAT_TYPE_residency_set, 'physmem' = SYSTAT_TYPE_physmem_set, 'highwater' = SYSTAT_TYPE_highwater_set, 'malloc' = SYSTAT_TYPE_malloc_set, 'mpl' = SYSTAT_TYPE_mpl_set, 'maxN' = SYSTAT_TYPE_maxN_set, 'maxTP' = SYSTAT_TYPE_maxTP_set, 'minRT' = SYSTAT_TYPE_minRT_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
setMethod('[[<-', c('_p_SYSTAT_TYPE', 'character'),function(x, i, j, ..., value)

{
  name = i
  accessorFuns = list('response' = SYSTAT_TYPE_response_set, 'thruput' = SYSTAT_TYPE_thruput_set, 'residency' = SYSTAT_TYPE_residency_set, 'physmem' = SYSTAT_TYPE_physmem_set, 'highwater' = SYSTAT_TYPE_highwater_set, 'malloc' = SYSTAT_TYPE_malloc_set, 'mpl' = SYSTAT_TYPE_mpl_set, 'maxN' = SYSTAT_TYPE_maxN_set, 'maxTP' = SYSTAT_TYPE_maxTP_set, 'minRT' = SYSTAT_TYPE_minRT_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
# end of accessor method for SYSTAT_TYPE
setMethod('delete', '_p_SYSTAT_TYPE', function(obj) {delete_SYSTAT_TYPE(obj)})
# Start definition of copy functions & methods for SYSTAT_TYPE
CopyToR_SYSTAT_TYPE = function(value, obj = new("SYSTAT_TYPE"))
{
  obj@response = value$response
  obj@thruput = value$thruput
  obj@residency = value$residency
  obj@physmem = value$physmem
  obj@highwater = value$highwater
  obj@malloc = value$malloc
  obj@mpl = value$mpl
  obj@maxN = value$maxN
  obj@maxTP = value$maxTP
  obj@minRT = value$minRT
  obj
}



CopyToC_SYSTAT_TYPE = function(value, obj)
{
  obj$response = value@response
  obj$thruput = value@thruput
  obj$residency = value@residency
  obj$physmem = value@physmem
  obj$highwater = value@highwater
  obj$malloc = value@malloc
  obj$mpl = value@mpl
  obj$maxN = value@maxN
  obj$maxTP = value@maxTP
  obj$minRT = value@minRT
  obj
}



# Start definition of copy methods for SYSTAT_TYPE
setMethod('copyToR', '_p_SYSTAT_TYPE', CopyToR_SYSTAT_TYPE)
setMethod('copyToC', 'SYSTAT_TYPE', CopyToC_SYSTAT_TYPE)

# End definition of copy methods for SYSTAT_TYPE
# End definition of copy functions & methods for SYSTAT_TYPE
# Start of TERMINAL_TYPE_name_set

`TERMINAL_TYPE_name_set` = function(self, s_name)
{
  self = coerceIfNotSubclass(self, "_p_TERMINAL_TYPE") 
  
  if(is.list(s_name))
  assert(all(sapply(s_name, class) == "_p_char"))     
  
  
#  assert(length(s_name) >= 64)
  
  .Call('R_swig_TERMINAL_TYPE_name_set', self, s_name, PACKAGE='pdq')
  
}

attr(`TERMINAL_TYPE_name_set`, 'returnType') = 'void'
attr(`TERMINAL_TYPE_name_set`, "inputTypes") = c('_p_TERMINAL_TYPE', '_p_char')
class(`TERMINAL_TYPE_name_set`) = c("SWIGFunction", class('TERMINAL_TYPE_name_set'))

# Start of TERMINAL_TYPE_name_get

`TERMINAL_TYPE_name_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_TERMINAL_TYPE") 
  ans = .Call('R_swig_TERMINAL_TYPE_name_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_char"
  
  ans
  
}

attr(`TERMINAL_TYPE_name_get`, 'returnType') = '_p_char'
attr(`TERMINAL_TYPE_name_get`, "inputTypes") = c('_p_TERMINAL_TYPE')
class(`TERMINAL_TYPE_name_get`) = c("SWIGFunction", class('TERMINAL_TYPE_name_get'))

# Start of TERMINAL_TYPE_pop_set

`TERMINAL_TYPE_pop_set` = function(self, s_pop)
{
  self = coerceIfNotSubclass(self, "_p_TERMINAL_TYPE") 
  s_pop = as.numeric(s_pop) 
  .Call('R_swig_TERMINAL_TYPE_pop_set', self, s_pop, PACKAGE='pdq')
  
}

attr(`TERMINAL_TYPE_pop_set`, 'returnType') = 'void'
attr(`TERMINAL_TYPE_pop_set`, "inputTypes") = c('_p_TERMINAL_TYPE', 'numeric')
class(`TERMINAL_TYPE_pop_set`) = c("SWIGFunction", class('TERMINAL_TYPE_pop_set'))

# Start of TERMINAL_TYPE_pop_get

`TERMINAL_TYPE_pop_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_TERMINAL_TYPE") 
  .Call('R_swig_TERMINAL_TYPE_pop_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`TERMINAL_TYPE_pop_get`, 'returnType') = 'numeric'
attr(`TERMINAL_TYPE_pop_get`, "inputTypes") = c('_p_TERMINAL_TYPE')
class(`TERMINAL_TYPE_pop_get`) = c("SWIGFunction", class('TERMINAL_TYPE_pop_get'))

# Start of TERMINAL_TYPE_think_set

`TERMINAL_TYPE_think_set` = function(self, s_think)
{
  self = coerceIfNotSubclass(self, "_p_TERMINAL_TYPE") 
  s_think = as.numeric(s_think) 
  .Call('R_swig_TERMINAL_TYPE_think_set', self, s_think, PACKAGE='pdq')
  
}

attr(`TERMINAL_TYPE_think_set`, 'returnType') = 'void'
attr(`TERMINAL_TYPE_think_set`, "inputTypes") = c('_p_TERMINAL_TYPE', 'numeric')
class(`TERMINAL_TYPE_think_set`) = c("SWIGFunction", class('TERMINAL_TYPE_think_set'))

# Start of TERMINAL_TYPE_think_get

`TERMINAL_TYPE_think_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_TERMINAL_TYPE") 
  .Call('R_swig_TERMINAL_TYPE_think_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`TERMINAL_TYPE_think_get`, 'returnType') = 'numeric'
attr(`TERMINAL_TYPE_think_get`, "inputTypes") = c('_p_TERMINAL_TYPE')
class(`TERMINAL_TYPE_think_get`) = c("SWIGFunction", class('TERMINAL_TYPE_think_get'))

# Start of TERMINAL_TYPE_sys_set

`TERMINAL_TYPE_sys_set` = function(self, s_sys)
{
  self = coerceIfNotSubclass(self, "_p_TERMINAL_TYPE") 
  s_sys = coerceIfNotSubclass(s_sys, "_p_SYSTAT_TYPE") 
  .Call('R_swig_TERMINAL_TYPE_sys_set', self, s_sys, PACKAGE='pdq')
  
}

attr(`TERMINAL_TYPE_sys_set`, 'returnType') = 'void'
attr(`TERMINAL_TYPE_sys_set`, "inputTypes") = c('_p_TERMINAL_TYPE', '_p_SYSTAT_TYPE')
class(`TERMINAL_TYPE_sys_set`) = c("SWIGFunction", class('TERMINAL_TYPE_sys_set'))

# Start of TERMINAL_TYPE_sys_get

`TERMINAL_TYPE_sys_get` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_TERMINAL_TYPE") 
  ans = .Call('R_swig_TERMINAL_TYPE_sys_get', self, PACKAGE='pdq')
  class(ans) <- "_p_SYSTAT_TYPE"
  
  ans
  
}

attr(`TERMINAL_TYPE_sys_get`, 'returnType') = '_p_SYSTAT_TYPE'
attr(`TERMINAL_TYPE_sys_get`, "inputTypes") = c('_p_TERMINAL_TYPE')
class(`TERMINAL_TYPE_sys_get`) = c("SWIGFunction", class('TERMINAL_TYPE_sys_get'))

# Start of new_TERMINAL_TYPE

`TERMINAL_TYPE` = function()
{
  ans = .Call('R_swig_new_TERMINAL_TYPE', PACKAGE='pdq')
  class(ans) <- "_p_TERMINAL_TYPE"
  
  ans
  
}

attr(`TERMINAL_TYPE`, 'returnType') = '_p_TERMINAL_TYPE'
class(`TERMINAL_TYPE`) = c("SWIGFunction", class('TERMINAL_TYPE'))

# Start of delete_TERMINAL_TYPE

`delete_TERMINAL_TYPE` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_TERMINAL_TYPE") 
  .Call('R_swig_delete_TERMINAL_TYPE', self, PACKAGE='pdq')
  
}

attr(`delete_TERMINAL_TYPE`, 'returnType') = 'void'
attr(`delete_TERMINAL_TYPE`, "inputTypes") = c('_p_TERMINAL_TYPE')
class(`delete_TERMINAL_TYPE`) = c("SWIGFunction", class('delete_TERMINAL_TYPE'))

# Start of accessor method for TERMINAL_TYPE
setMethod('$', '_p_TERMINAL_TYPE', function(x, name)

{
  accessorFuns = list('name' = TERMINAL_TYPE_name_get, 'pop' = TERMINAL_TYPE_pop_get, 'think' = TERMINAL_TYPE_think_get, 'sys' = TERMINAL_TYPE_sys_get)
  vaccessors = c('name', 'pop', 'think', 'sys')
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name))
  f = accessorFuns[[idx]]
  formals(f)[[1]] = x
  if (is.na(match(name, vaccessors))) f else f(x)
}


)
# end of accessor method for TERMINAL_TYPE
# Start of accessor method for TERMINAL_TYPE
setMethod('$<-', '_p_TERMINAL_TYPE', function(x, name, value)

{
  accessorFuns = list('name' = TERMINAL_TYPE_name_set, 'pop' = TERMINAL_TYPE_pop_set, 'think' = TERMINAL_TYPE_think_set, 'sys' = TERMINAL_TYPE_sys_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
setMethod('[[<-', c('_p_TERMINAL_TYPE', 'character'),function(x, i, j, ..., value)

{
  name = i
  accessorFuns = list('name' = TERMINAL_TYPE_name_set, 'pop' = TERMINAL_TYPE_pop_set, 'think' = TERMINAL_TYPE_think_set, 'sys' = TERMINAL_TYPE_sys_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
# end of accessor method for TERMINAL_TYPE
setMethod('delete', '_p_TERMINAL_TYPE', function(obj) {delete_TERMINAL_TYPE(obj)})
# Start definition of copy functions & methods for TERMINAL_TYPE
CopyToR_TERMINAL_TYPE = function(value, obj = new("TERMINAL_TYPE"))
{
  obj@name = value$name
  obj@pop = value$pop
  obj@think = value$think
  obj
}



CopyToC_TERMINAL_TYPE = function(value, obj)
{
  obj$name = value@name
  obj$pop = value@pop
  obj$think = value@think
  obj
}



# Start definition of copy methods for TERMINAL_TYPE
setMethod('copyToR', '_p_TERMINAL_TYPE', CopyToR_TERMINAL_TYPE)
setMethod('copyToC', 'TERMINAL_TYPE', CopyToC_TERMINAL_TYPE)

# End definition of copy methods for TERMINAL_TYPE
# End definition of copy functions & methods for TERMINAL_TYPE
# Start of BATCH_TYPE_name_set

`BATCH_TYPE_name_set` = function(self, s_name)
{
  self = coerceIfNotSubclass(self, "_p_BATCH_TYPE") 
  
  if(is.list(s_name))
  assert(all(sapply(s_name, class) == "_p_char"))     
  
  
#  assert(length(s_name) >= 64)
  
  .Call('R_swig_BATCH_TYPE_name_set', self, s_name, PACKAGE='pdq')
  
}

attr(`BATCH_TYPE_name_set`, 'returnType') = 'void'
attr(`BATCH_TYPE_name_set`, "inputTypes") = c('_p_BATCH_TYPE', '_p_char')
class(`BATCH_TYPE_name_set`) = c("SWIGFunction", class('BATCH_TYPE_name_set'))

# Start of BATCH_TYPE_name_get

`BATCH_TYPE_name_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_BATCH_TYPE") 
  ans = .Call('R_swig_BATCH_TYPE_name_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_char"
  
  ans
  
}

attr(`BATCH_TYPE_name_get`, 'returnType') = '_p_char'
attr(`BATCH_TYPE_name_get`, "inputTypes") = c('_p_BATCH_TYPE')
class(`BATCH_TYPE_name_get`) = c("SWIGFunction", class('BATCH_TYPE_name_get'))

# Start of BATCH_TYPE_pop_set

`BATCH_TYPE_pop_set` = function(self, s_pop)
{
  self = coerceIfNotSubclass(self, "_p_BATCH_TYPE") 
  s_pop = as.numeric(s_pop) 
  .Call('R_swig_BATCH_TYPE_pop_set', self, s_pop, PACKAGE='pdq')
  
}

attr(`BATCH_TYPE_pop_set`, 'returnType') = 'void'
attr(`BATCH_TYPE_pop_set`, "inputTypes") = c('_p_BATCH_TYPE', 'numeric')
class(`BATCH_TYPE_pop_set`) = c("SWIGFunction", class('BATCH_TYPE_pop_set'))

# Start of BATCH_TYPE_pop_get

`BATCH_TYPE_pop_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_BATCH_TYPE") 
  .Call('R_swig_BATCH_TYPE_pop_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`BATCH_TYPE_pop_get`, 'returnType') = 'numeric'
attr(`BATCH_TYPE_pop_get`, "inputTypes") = c('_p_BATCH_TYPE')
class(`BATCH_TYPE_pop_get`) = c("SWIGFunction", class('BATCH_TYPE_pop_get'))

# Start of BATCH_TYPE_sys_set

`BATCH_TYPE_sys_set` = function(self, s_sys)
{
  self = coerceIfNotSubclass(self, "_p_BATCH_TYPE") 
  s_sys = coerceIfNotSubclass(s_sys, "_p_SYSTAT_TYPE") 
  .Call('R_swig_BATCH_TYPE_sys_set', self, s_sys, PACKAGE='pdq')
  
}

attr(`BATCH_TYPE_sys_set`, 'returnType') = 'void'
attr(`BATCH_TYPE_sys_set`, "inputTypes") = c('_p_BATCH_TYPE', '_p_SYSTAT_TYPE')
class(`BATCH_TYPE_sys_set`) = c("SWIGFunction", class('BATCH_TYPE_sys_set'))

# Start of BATCH_TYPE_sys_get

`BATCH_TYPE_sys_get` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_BATCH_TYPE") 
  ans = .Call('R_swig_BATCH_TYPE_sys_get', self, PACKAGE='pdq')
  class(ans) <- "_p_SYSTAT_TYPE"
  
  ans
  
}

attr(`BATCH_TYPE_sys_get`, 'returnType') = '_p_SYSTAT_TYPE'
attr(`BATCH_TYPE_sys_get`, "inputTypes") = c('_p_BATCH_TYPE')
class(`BATCH_TYPE_sys_get`) = c("SWIGFunction", class('BATCH_TYPE_sys_get'))

# Start of new_BATCH_TYPE

`BATCH_TYPE` = function()
{
  ans = .Call('R_swig_new_BATCH_TYPE', PACKAGE='pdq')
  class(ans) <- "_p_BATCH_TYPE"
  
  ans
  
}

attr(`BATCH_TYPE`, 'returnType') = '_p_BATCH_TYPE'
class(`BATCH_TYPE`) = c("SWIGFunction", class('BATCH_TYPE'))

# Start of delete_BATCH_TYPE

`delete_BATCH_TYPE` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_BATCH_TYPE") 
  .Call('R_swig_delete_BATCH_TYPE', self, PACKAGE='pdq')
  
}

attr(`delete_BATCH_TYPE`, 'returnType') = 'void'
attr(`delete_BATCH_TYPE`, "inputTypes") = c('_p_BATCH_TYPE')
class(`delete_BATCH_TYPE`) = c("SWIGFunction", class('delete_BATCH_TYPE'))

# Start of accessor method for BATCH_TYPE
setMethod('$', '_p_BATCH_TYPE', function(x, name)

{
  accessorFuns = list('name' = BATCH_TYPE_name_get, 'pop' = BATCH_TYPE_pop_get, 'sys' = BATCH_TYPE_sys_get)
  vaccessors = c('name', 'pop', 'sys')
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name))
  f = accessorFuns[[idx]]
  formals(f)[[1]] = x
  if (is.na(match(name, vaccessors))) f else f(x)
}


)
# end of accessor method for BATCH_TYPE
# Start of accessor method for BATCH_TYPE
setMethod('$<-', '_p_BATCH_TYPE', function(x, name, value)

{
  accessorFuns = list('name' = BATCH_TYPE_name_set, 'pop' = BATCH_TYPE_pop_set, 'sys' = BATCH_TYPE_sys_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
setMethod('[[<-', c('_p_BATCH_TYPE', 'character'),function(x, i, j, ..., value)

{
  name = i
  accessorFuns = list('name' = BATCH_TYPE_name_set, 'pop' = BATCH_TYPE_pop_set, 'sys' = BATCH_TYPE_sys_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
# end of accessor method for BATCH_TYPE
setMethod('delete', '_p_BATCH_TYPE', function(obj) {delete_BATCH_TYPE(obj)})
# Start definition of copy functions & methods for BATCH_TYPE
CopyToR_BATCH_TYPE = function(value, obj = new("BATCH_TYPE"))
{
  obj@name = value$name
  obj@pop = value$pop
  obj
}



CopyToC_BATCH_TYPE = function(value, obj)
{
  obj$name = value@name
  obj$pop = value@pop
  obj
}



# Start definition of copy methods for BATCH_TYPE
setMethod('copyToR', '_p_BATCH_TYPE', CopyToR_BATCH_TYPE)
setMethod('copyToC', 'BATCH_TYPE', CopyToC_BATCH_TYPE)

# End definition of copy methods for BATCH_TYPE
# End definition of copy functions & methods for BATCH_TYPE
# Start of TRANSACTION_TYPE_name_set

`TRANSACTION_TYPE_name_set` = function(self, s_name)
{
  self = coerceIfNotSubclass(self, "_p_TRANSACTION_TYPE") 
  
  if(is.list(s_name))
  assert(all(sapply(s_name, class) == "_p_char"))     
  
  
#  assert(length(s_name) >= 64)
  
  .Call('R_swig_TRANSACTION_TYPE_name_set', self, s_name, PACKAGE='pdq')
  
}

attr(`TRANSACTION_TYPE_name_set`, 'returnType') = 'void'
attr(`TRANSACTION_TYPE_name_set`, "inputTypes") = c('_p_TRANSACTION_TYPE', '_p_char')
class(`TRANSACTION_TYPE_name_set`) = c("SWIGFunction", class('TRANSACTION_TYPE_name_set'))

# Start of TRANSACTION_TYPE_name_get

`TRANSACTION_TYPE_name_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_TRANSACTION_TYPE") 
  ans = .Call('R_swig_TRANSACTION_TYPE_name_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_char"
  
  ans
  
}

attr(`TRANSACTION_TYPE_name_get`, 'returnType') = '_p_char'
attr(`TRANSACTION_TYPE_name_get`, "inputTypes") = c('_p_TRANSACTION_TYPE')
class(`TRANSACTION_TYPE_name_get`) = c("SWIGFunction", class('TRANSACTION_TYPE_name_get'))

# Start of TRANSACTION_TYPE_arrival_rate_set

`TRANSACTION_TYPE_arrival_rate_set` = function(self, s_arrival_rate)
{
  self = coerceIfNotSubclass(self, "_p_TRANSACTION_TYPE") 
  s_arrival_rate = as.numeric(s_arrival_rate) 
  .Call('R_swig_TRANSACTION_TYPE_arrival_rate_set', self, s_arrival_rate, PACKAGE='pdq')
  
}

attr(`TRANSACTION_TYPE_arrival_rate_set`, 'returnType') = 'void'
attr(`TRANSACTION_TYPE_arrival_rate_set`, "inputTypes") = c('_p_TRANSACTION_TYPE', 'numeric')
class(`TRANSACTION_TYPE_arrival_rate_set`) = c("SWIGFunction", class('TRANSACTION_TYPE_arrival_rate_set'))

# Start of TRANSACTION_TYPE_arrival_rate_get

`TRANSACTION_TYPE_arrival_rate_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_TRANSACTION_TYPE") 
  .Call('R_swig_TRANSACTION_TYPE_arrival_rate_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`TRANSACTION_TYPE_arrival_rate_get`, 'returnType') = 'numeric'
attr(`TRANSACTION_TYPE_arrival_rate_get`, "inputTypes") = c('_p_TRANSACTION_TYPE')
class(`TRANSACTION_TYPE_arrival_rate_get`) = c("SWIGFunction", class('TRANSACTION_TYPE_arrival_rate_get'))

# Start of TRANSACTION_TYPE_saturation_rate_set

`TRANSACTION_TYPE_saturation_rate_set` = function(self, s_saturation_rate)
{
  self = coerceIfNotSubclass(self, "_p_TRANSACTION_TYPE") 
  s_saturation_rate = as.numeric(s_saturation_rate) 
  .Call('R_swig_TRANSACTION_TYPE_saturation_rate_set', self, s_saturation_rate, PACKAGE='pdq')
  
}

attr(`TRANSACTION_TYPE_saturation_rate_set`, 'returnType') = 'void'
attr(`TRANSACTION_TYPE_saturation_rate_set`, "inputTypes") = c('_p_TRANSACTION_TYPE', 'numeric')
class(`TRANSACTION_TYPE_saturation_rate_set`) = c("SWIGFunction", class('TRANSACTION_TYPE_saturation_rate_set'))

# Start of TRANSACTION_TYPE_saturation_rate_get

`TRANSACTION_TYPE_saturation_rate_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_TRANSACTION_TYPE") 
  .Call('R_swig_TRANSACTION_TYPE_saturation_rate_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`TRANSACTION_TYPE_saturation_rate_get`, 'returnType') = 'numeric'
attr(`TRANSACTION_TYPE_saturation_rate_get`, "inputTypes") = c('_p_TRANSACTION_TYPE')
class(`TRANSACTION_TYPE_saturation_rate_get`) = c("SWIGFunction", class('TRANSACTION_TYPE_saturation_rate_get'))

# Start of TRANSACTION_TYPE_sys_set

`TRANSACTION_TYPE_sys_set` = function(self, s_sys)
{
  self = coerceIfNotSubclass(self, "_p_TRANSACTION_TYPE") 
  s_sys = coerceIfNotSubclass(s_sys, "_p_SYSTAT_TYPE") 
  .Call('R_swig_TRANSACTION_TYPE_sys_set', self, s_sys, PACKAGE='pdq')
  
}

attr(`TRANSACTION_TYPE_sys_set`, 'returnType') = 'void'
attr(`TRANSACTION_TYPE_sys_set`, "inputTypes") = c('_p_TRANSACTION_TYPE', '_p_SYSTAT_TYPE')
class(`TRANSACTION_TYPE_sys_set`) = c("SWIGFunction", class('TRANSACTION_TYPE_sys_set'))

# Start of TRANSACTION_TYPE_sys_get

`TRANSACTION_TYPE_sys_get` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_TRANSACTION_TYPE") 
  ans = .Call('R_swig_TRANSACTION_TYPE_sys_get', self, PACKAGE='pdq')
  class(ans) <- "_p_SYSTAT_TYPE"
  
  ans
  
}

attr(`TRANSACTION_TYPE_sys_get`, 'returnType') = '_p_SYSTAT_TYPE'
attr(`TRANSACTION_TYPE_sys_get`, "inputTypes") = c('_p_TRANSACTION_TYPE')
class(`TRANSACTION_TYPE_sys_get`) = c("SWIGFunction", class('TRANSACTION_TYPE_sys_get'))

# Start of new_TRANSACTION_TYPE

`TRANSACTION_TYPE` = function()
{
  ans = .Call('R_swig_new_TRANSACTION_TYPE', PACKAGE='pdq')
  class(ans) <- "_p_TRANSACTION_TYPE"
  
  ans
  
}

attr(`TRANSACTION_TYPE`, 'returnType') = '_p_TRANSACTION_TYPE'
class(`TRANSACTION_TYPE`) = c("SWIGFunction", class('TRANSACTION_TYPE'))

# Start of delete_TRANSACTION_TYPE

`delete_TRANSACTION_TYPE` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_TRANSACTION_TYPE") 
  .Call('R_swig_delete_TRANSACTION_TYPE', self, PACKAGE='pdq')
  
}

attr(`delete_TRANSACTION_TYPE`, 'returnType') = 'void'
attr(`delete_TRANSACTION_TYPE`, "inputTypes") = c('_p_TRANSACTION_TYPE')
class(`delete_TRANSACTION_TYPE`) = c("SWIGFunction", class('delete_TRANSACTION_TYPE'))

# Start of accessor method for TRANSACTION_TYPE
setMethod('$', '_p_TRANSACTION_TYPE', function(x, name)

{
  accessorFuns = list('name' = TRANSACTION_TYPE_name_get, 'arrival_rate' = TRANSACTION_TYPE_arrival_rate_get, 'saturation_rate' = TRANSACTION_TYPE_saturation_rate_get, 'sys' = TRANSACTION_TYPE_sys_get)
  vaccessors = c('name', 'arrival_rate', 'saturation_rate', 'sys')
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name))
  f = accessorFuns[[idx]]
  formals(f)[[1]] = x
  if (is.na(match(name, vaccessors))) f else f(x)
}


)
# end of accessor method for TRANSACTION_TYPE
# Start of accessor method for TRANSACTION_TYPE
setMethod('$<-', '_p_TRANSACTION_TYPE', function(x, name, value)

{
  accessorFuns = list('name' = TRANSACTION_TYPE_name_set, 'arrival_rate' = TRANSACTION_TYPE_arrival_rate_set, 'saturation_rate' = TRANSACTION_TYPE_saturation_rate_set, 'sys' = TRANSACTION_TYPE_sys_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
setMethod('[[<-', c('_p_TRANSACTION_TYPE', 'character'),function(x, i, j, ..., value)

{
  name = i
  accessorFuns = list('name' = TRANSACTION_TYPE_name_set, 'arrival_rate' = TRANSACTION_TYPE_arrival_rate_set, 'saturation_rate' = TRANSACTION_TYPE_saturation_rate_set, 'sys' = TRANSACTION_TYPE_sys_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
# end of accessor method for TRANSACTION_TYPE
setMethod('delete', '_p_TRANSACTION_TYPE', function(obj) {delete_TRANSACTION_TYPE(obj)})
# Start definition of copy functions & methods for TRANSACTION_TYPE
CopyToR_TRANSACTION_TYPE = function(value, obj = new("TRANSACTION_TYPE"))
{
  obj@name = value$name
  obj@arrival_rate = value$arrival_rate
  obj@saturation_rate = value$saturation_rate
  obj
}



CopyToC_TRANSACTION_TYPE = function(value, obj)
{
  obj$name = value@name
  obj$arrival_rate = value@arrival_rate
  obj$saturation_rate = value@saturation_rate
  obj
}



# Start definition of copy methods for TRANSACTION_TYPE
setMethod('copyToR', '_p_TRANSACTION_TYPE', CopyToR_TRANSACTION_TYPE)
setMethod('copyToC', 'TRANSACTION_TYPE', CopyToC_TRANSACTION_TYPE)

# End definition of copy methods for TRANSACTION_TYPE
# End definition of copy functions & methods for TRANSACTION_TYPE
# Start of JOB_TYPE_should_be_class_set

`JOB_TYPE_should_be_class_set` = function(self, s_should_be_class)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  s_should_be_class = as.integer(s_should_be_class) 
  
  if(length(s_should_be_class) > 1) {
    Rf_warning("using only the first element of s_should_be_class")
  }
  
  .Call('R_swig_JOB_TYPE_should_be_class_set', self, s_should_be_class, PACKAGE='pdq')
  
}

attr(`JOB_TYPE_should_be_class_set`, 'returnType') = 'void'
attr(`JOB_TYPE_should_be_class_set`, "inputTypes") = c('_p_JOB_TYPE', 'numeric')
class(`JOB_TYPE_should_be_class_set`) = c("SWIGFunction", class('JOB_TYPE_should_be_class_set'))

# Start of JOB_TYPE_should_be_class_get

`JOB_TYPE_should_be_class_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  .Call('R_swig_JOB_TYPE_should_be_class_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`JOB_TYPE_should_be_class_get`, 'returnType') = 'numeric'
attr(`JOB_TYPE_should_be_class_get`, "inputTypes") = c('_p_JOB_TYPE')
class(`JOB_TYPE_should_be_class_get`) = c("SWIGFunction", class('JOB_TYPE_should_be_class_get'))

# Start of JOB_TYPE_network_set

`JOB_TYPE_network_set` = function(self, s_network)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  s_network = as.integer(s_network) 
  
  if(length(s_network) > 1) {
    Rf_warning("using only the first element of s_network")
  }
  
  .Call('R_swig_JOB_TYPE_network_set', self, s_network, PACKAGE='pdq')
  
}

attr(`JOB_TYPE_network_set`, 'returnType') = 'void'
attr(`JOB_TYPE_network_set`, "inputTypes") = c('_p_JOB_TYPE', 'numeric')
class(`JOB_TYPE_network_set`) = c("SWIGFunction", class('JOB_TYPE_network_set'))

# Start of JOB_TYPE_network_get

`JOB_TYPE_network_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  .Call('R_swig_JOB_TYPE_network_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`JOB_TYPE_network_get`, 'returnType') = 'numeric'
attr(`JOB_TYPE_network_get`, "inputTypes") = c('_p_JOB_TYPE')
class(`JOB_TYPE_network_get`) = c("SWIGFunction", class('JOB_TYPE_network_get'))

# Start of JOB_TYPE_term_set

`JOB_TYPE_term_set` = function(self, s_term)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  s_term = coerceIfNotSubclass(s_term, "_p_TERMINAL_TYPE") 
  .Call('R_swig_JOB_TYPE_term_set', self, s_term, PACKAGE='pdq')
  
}

attr(`JOB_TYPE_term_set`, 'returnType') = 'void'
attr(`JOB_TYPE_term_set`, "inputTypes") = c('_p_JOB_TYPE', '_p_TERMINAL_TYPE')
class(`JOB_TYPE_term_set`) = c("SWIGFunction", class('JOB_TYPE_term_set'))

# Start of JOB_TYPE_term_get

`JOB_TYPE_term_get` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  ans = .Call('R_swig_JOB_TYPE_term_get', self, PACKAGE='pdq')
  class(ans) <- "_p_TERMINAL_TYPE"
  
  ans
  
}

attr(`JOB_TYPE_term_get`, 'returnType') = '_p_TERMINAL_TYPE'
attr(`JOB_TYPE_term_get`, "inputTypes") = c('_p_JOB_TYPE')
class(`JOB_TYPE_term_get`) = c("SWIGFunction", class('JOB_TYPE_term_get'))

# Start of JOB_TYPE_batch_set

`JOB_TYPE_batch_set` = function(self, s_batch)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  s_batch = coerceIfNotSubclass(s_batch, "_p_BATCH_TYPE") 
  .Call('R_swig_JOB_TYPE_batch_set', self, s_batch, PACKAGE='pdq')
  
}

attr(`JOB_TYPE_batch_set`, 'returnType') = 'void'
attr(`JOB_TYPE_batch_set`, "inputTypes") = c('_p_JOB_TYPE', '_p_BATCH_TYPE')
class(`JOB_TYPE_batch_set`) = c("SWIGFunction", class('JOB_TYPE_batch_set'))

# Start of JOB_TYPE_batch_get

`JOB_TYPE_batch_get` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  ans = .Call('R_swig_JOB_TYPE_batch_get', self, PACKAGE='pdq')
  class(ans) <- "_p_BATCH_TYPE"
  
  ans
  
}

attr(`JOB_TYPE_batch_get`, 'returnType') = '_p_BATCH_TYPE'
attr(`JOB_TYPE_batch_get`, "inputTypes") = c('_p_JOB_TYPE')
class(`JOB_TYPE_batch_get`) = c("SWIGFunction", class('JOB_TYPE_batch_get'))

# Start of JOB_TYPE_trans_set

`JOB_TYPE_trans_set` = function(self, s_trans)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  s_trans = coerceIfNotSubclass(s_trans, "_p_TRANSACTION_TYPE") 
  .Call('R_swig_JOB_TYPE_trans_set', self, s_trans, PACKAGE='pdq')
  
}

attr(`JOB_TYPE_trans_set`, 'returnType') = 'void'
attr(`JOB_TYPE_trans_set`, "inputTypes") = c('_p_JOB_TYPE', '_p_TRANSACTION_TYPE')
class(`JOB_TYPE_trans_set`) = c("SWIGFunction", class('JOB_TYPE_trans_set'))

# Start of JOB_TYPE_trans_get

`JOB_TYPE_trans_get` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  ans = .Call('R_swig_JOB_TYPE_trans_get', self, PACKAGE='pdq')
  class(ans) <- "_p_TRANSACTION_TYPE"
  
  ans
  
}

attr(`JOB_TYPE_trans_get`, 'returnType') = '_p_TRANSACTION_TYPE'
attr(`JOB_TYPE_trans_get`, "inputTypes") = c('_p_JOB_TYPE')
class(`JOB_TYPE_trans_get`) = c("SWIGFunction", class('JOB_TYPE_trans_get'))

# Start of new_JOB_TYPE

`JOB_TYPE` = function()
{
  ans = .Call('R_swig_new_JOB_TYPE', PACKAGE='pdq')
  class(ans) <- "_p_JOB_TYPE"
  
  ans
  
}

attr(`JOB_TYPE`, 'returnType') = '_p_JOB_TYPE'
class(`JOB_TYPE`) = c("SWIGFunction", class('JOB_TYPE'))

# Start of delete_JOB_TYPE

`delete_JOB_TYPE` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_JOB_TYPE") 
  .Call('R_swig_delete_JOB_TYPE', self, PACKAGE='pdq')
  
}

attr(`delete_JOB_TYPE`, 'returnType') = 'void'
attr(`delete_JOB_TYPE`, "inputTypes") = c('_p_JOB_TYPE')
class(`delete_JOB_TYPE`) = c("SWIGFunction", class('delete_JOB_TYPE'))

# Start of accessor method for JOB_TYPE
setMethod('$', '_p_JOB_TYPE', function(x, name)

{
  accessorFuns = list('should_be_class' = JOB_TYPE_should_be_class_get, 'network' = JOB_TYPE_network_get, 'term' = JOB_TYPE_term_get, 'batch' = JOB_TYPE_batch_get, 'trans' = JOB_TYPE_trans_get)
  vaccessors = c('should_be_class', 'network', 'term', 'batch', 'trans')
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name))
  f = accessorFuns[[idx]]
  formals(f)[[1]] = x
  if (is.na(match(name, vaccessors))) f else f(x)
}


)
# end of accessor method for JOB_TYPE
# Start of accessor method for JOB_TYPE
setMethod('$<-', '_p_JOB_TYPE', function(x, name, value)

{
  accessorFuns = list('should_be_class' = JOB_TYPE_should_be_class_set, 'network' = JOB_TYPE_network_set, 'term' = JOB_TYPE_term_set, 'batch' = JOB_TYPE_batch_set, 'trans' = JOB_TYPE_trans_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
setMethod('[[<-', c('_p_JOB_TYPE', 'character'),function(x, i, j, ..., value)

{
  name = i
  accessorFuns = list('should_be_class' = JOB_TYPE_should_be_class_set, 'network' = JOB_TYPE_network_set, 'term' = JOB_TYPE_term_set, 'batch' = JOB_TYPE_batch_set, 'trans' = JOB_TYPE_trans_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
# end of accessor method for JOB_TYPE
setMethod('delete', '_p_JOB_TYPE', function(obj) {delete_JOB_TYPE(obj)})
# Start definition of copy functions & methods for JOB_TYPE
CopyToR_JOB_TYPE = function(value, obj = new("JOB_TYPE"))
{
  obj@should_be_class = value$should_be_class
  obj@network = value$network
  obj
}



CopyToC_JOB_TYPE = function(value, obj)
{
  obj$should_be_class = value@should_be_class
  obj$network = value@network
  obj
}



# Start definition of copy methods for JOB_TYPE
setMethod('copyToR', '_p_JOB_TYPE', CopyToR_JOB_TYPE)
setMethod('copyToC', 'JOB_TYPE', CopyToC_JOB_TYPE)

# End definition of copy methods for JOB_TYPE
# End definition of copy functions & methods for JOB_TYPE
# Start of NODE_TYPE_devtype_set

`NODE_TYPE_devtype_set` = function(self, s_devtype)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  s_devtype = as.integer(s_devtype) 
  
  if(length(s_devtype) > 1) {
    Rf_warning("using only the first element of s_devtype")
  }
  
  .Call('R_swig_NODE_TYPE_devtype_set', self, s_devtype, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_devtype_set`, 'returnType') = 'void'
attr(`NODE_TYPE_devtype_set`, "inputTypes") = c('_p_NODE_TYPE', 'numeric')
class(`NODE_TYPE_devtype_set`) = c("SWIGFunction", class('NODE_TYPE_devtype_set'))

# Start of NODE_TYPE_devtype_get

`NODE_TYPE_devtype_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  .Call('R_swig_NODE_TYPE_devtype_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`NODE_TYPE_devtype_get`, 'returnType') = 'numeric'
attr(`NODE_TYPE_devtype_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_devtype_get`) = c("SWIGFunction", class('NODE_TYPE_devtype_get'))

# Start of NODE_TYPE_sched_set

`NODE_TYPE_sched_set` = function(self, s_sched)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  s_sched = as.integer(s_sched) 
  
  if(length(s_sched) > 1) {
    Rf_warning("using only the first element of s_sched")
  }
  
  .Call('R_swig_NODE_TYPE_sched_set', self, s_sched, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_sched_set`, 'returnType') = 'void'
attr(`NODE_TYPE_sched_set`, "inputTypes") = c('_p_NODE_TYPE', 'numeric')
class(`NODE_TYPE_sched_set`) = c("SWIGFunction", class('NODE_TYPE_sched_set'))

# Start of NODE_TYPE_sched_get

`NODE_TYPE_sched_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  .Call('R_swig_NODE_TYPE_sched_get', self, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`NODE_TYPE_sched_get`, 'returnType') = 'numeric'
attr(`NODE_TYPE_sched_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_sched_get`) = c("SWIGFunction", class('NODE_TYPE_sched_get'))

# Start of NODE_TYPE_devname_set

`NODE_TYPE_devname_set` = function(self, s_devname)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  
  if(is.list(s_devname))
  assert(all(sapply(s_devname, class) == "_p_char"))     
  
  
#  assert(length(s_devname) >= 64)
  
  .Call('R_swig_NODE_TYPE_devname_set', self, s_devname, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_devname_set`, 'returnType') = 'void'
attr(`NODE_TYPE_devname_set`, "inputTypes") = c('_p_NODE_TYPE', '_p_char')
class(`NODE_TYPE_devname_set`) = c("SWIGFunction", class('NODE_TYPE_devname_set'))

# Start of NODE_TYPE_devname_get

`NODE_TYPE_devname_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  ans = .Call('R_swig_NODE_TYPE_devname_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_char"
  
  ans
  
}

attr(`NODE_TYPE_devname_get`, 'returnType') = '_p_char'
attr(`NODE_TYPE_devname_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_devname_get`) = c("SWIGFunction", class('NODE_TYPE_devname_get'))

# Start of NODE_TYPE_visits_set

`NODE_TYPE_visits_set` = function(self, s_visits)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  s_visits = as.numeric(s_visits) 
  
#  assert(length(s_visits) >= 64)
  
  .Call('R_swig_NODE_TYPE_visits_set', self, s_visits, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_visits_set`, 'returnType') = 'void'
attr(`NODE_TYPE_visits_set`, "inputTypes") = c('_p_NODE_TYPE', '_p_double')
class(`NODE_TYPE_visits_set`) = c("SWIGFunction", class('NODE_TYPE_visits_set'))

# Start of NODE_TYPE_visits_get

`NODE_TYPE_visits_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  ans = .Call('R_swig_NODE_TYPE_visits_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_double"
  
  ans
  
}

attr(`NODE_TYPE_visits_get`, 'returnType') = '_p_double'
attr(`NODE_TYPE_visits_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_visits_get`) = c("SWIGFunction", class('NODE_TYPE_visits_get'))

# Start of NODE_TYPE_service_set

`NODE_TYPE_service_set` = function(self, s_service)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  s_service = as.numeric(s_service) 
  
#  assert(length(s_service) >= 64)
  
  .Call('R_swig_NODE_TYPE_service_set', self, s_service, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_service_set`, 'returnType') = 'void'
attr(`NODE_TYPE_service_set`, "inputTypes") = c('_p_NODE_TYPE', '_p_double')
class(`NODE_TYPE_service_set`) = c("SWIGFunction", class('NODE_TYPE_service_set'))

# Start of NODE_TYPE_service_get

`NODE_TYPE_service_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  ans = .Call('R_swig_NODE_TYPE_service_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_double"
  
  ans
  
}

attr(`NODE_TYPE_service_get`, 'returnType') = '_p_double'
attr(`NODE_TYPE_service_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_service_get`) = c("SWIGFunction", class('NODE_TYPE_service_get'))

# Start of NODE_TYPE_demand_set

`NODE_TYPE_demand_set` = function(self, s_demand)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  s_demand = as.numeric(s_demand) 
  
#  assert(length(s_demand) >= 64)
  
  .Call('R_swig_NODE_TYPE_demand_set', self, s_demand, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_demand_set`, 'returnType') = 'void'
attr(`NODE_TYPE_demand_set`, "inputTypes") = c('_p_NODE_TYPE', '_p_double')
class(`NODE_TYPE_demand_set`) = c("SWIGFunction", class('NODE_TYPE_demand_set'))

# Start of NODE_TYPE_demand_get

`NODE_TYPE_demand_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  ans = .Call('R_swig_NODE_TYPE_demand_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_double"
  
  ans
  
}

attr(`NODE_TYPE_demand_get`, 'returnType') = '_p_double'
attr(`NODE_TYPE_demand_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_demand_get`) = c("SWIGFunction", class('NODE_TYPE_demand_get'))

# Start of NODE_TYPE_resit_set

`NODE_TYPE_resit_set` = function(self, s_resit)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  s_resit = as.numeric(s_resit) 
  
#  assert(length(s_resit) >= 64)
  
  .Call('R_swig_NODE_TYPE_resit_set', self, s_resit, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_resit_set`, 'returnType') = 'void'
attr(`NODE_TYPE_resit_set`, "inputTypes") = c('_p_NODE_TYPE', '_p_double')
class(`NODE_TYPE_resit_set`) = c("SWIGFunction", class('NODE_TYPE_resit_set'))

# Start of NODE_TYPE_resit_get

`NODE_TYPE_resit_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  ans = .Call('R_swig_NODE_TYPE_resit_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_double"
  
  ans
  
}

attr(`NODE_TYPE_resit_get`, 'returnType') = '_p_double'
attr(`NODE_TYPE_resit_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_resit_get`) = c("SWIGFunction", class('NODE_TYPE_resit_get'))

# Start of NODE_TYPE_utiliz_set

`NODE_TYPE_utiliz_set` = function(self, s_utiliz)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  s_utiliz = as.numeric(s_utiliz) 
  
#  assert(length(s_utiliz) >= 64)
  
  .Call('R_swig_NODE_TYPE_utiliz_set', self, s_utiliz, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_utiliz_set`, 'returnType') = 'void'
attr(`NODE_TYPE_utiliz_set`, "inputTypes") = c('_p_NODE_TYPE', '_p_double')
class(`NODE_TYPE_utiliz_set`) = c("SWIGFunction", class('NODE_TYPE_utiliz_set'))

# Start of NODE_TYPE_utiliz_get

`NODE_TYPE_utiliz_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  ans = .Call('R_swig_NODE_TYPE_utiliz_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_double"
  
  ans
  
}

attr(`NODE_TYPE_utiliz_get`, 'returnType') = '_p_double'
attr(`NODE_TYPE_utiliz_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_utiliz_get`) = c("SWIGFunction", class('NODE_TYPE_utiliz_get'))

# Start of NODE_TYPE_qsize_set

`NODE_TYPE_qsize_set` = function(self, s_qsize)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  s_qsize = as.numeric(s_qsize) 
  
#  assert(length(s_qsize) >= 64)
  
  .Call('R_swig_NODE_TYPE_qsize_set', self, s_qsize, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_qsize_set`, 'returnType') = 'void'
attr(`NODE_TYPE_qsize_set`, "inputTypes") = c('_p_NODE_TYPE', '_p_double')
class(`NODE_TYPE_qsize_set`) = c("SWIGFunction", class('NODE_TYPE_qsize_set'))

# Start of NODE_TYPE_qsize_get

`NODE_TYPE_qsize_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  ans = .Call('R_swig_NODE_TYPE_qsize_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_double"
  
  ans
  
}

attr(`NODE_TYPE_qsize_get`, 'returnType') = '_p_double'
attr(`NODE_TYPE_qsize_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_qsize_get`) = c("SWIGFunction", class('NODE_TYPE_qsize_get'))

# Start of NODE_TYPE_avqsize_set

`NODE_TYPE_avqsize_set` = function(self, s_avqsize)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  s_avqsize = as.numeric(s_avqsize) 
  
#  assert(length(s_avqsize) >= 64)
  
  .Call('R_swig_NODE_TYPE_avqsize_set', self, s_avqsize, PACKAGE='pdq')
  
}

attr(`NODE_TYPE_avqsize_set`, 'returnType') = 'void'
attr(`NODE_TYPE_avqsize_set`, "inputTypes") = c('_p_NODE_TYPE', '_p_double')
class(`NODE_TYPE_avqsize_set`) = c("SWIGFunction", class('NODE_TYPE_avqsize_set'))

# Start of NODE_TYPE_avqsize_get

`NODE_TYPE_avqsize_get` = function(self, .copy = FALSE)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  ans = .Call('R_swig_NODE_TYPE_avqsize_get', self, as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_double"
  
  ans
  
}

attr(`NODE_TYPE_avqsize_get`, 'returnType') = '_p_double'
attr(`NODE_TYPE_avqsize_get`, "inputTypes") = c('_p_NODE_TYPE')
class(`NODE_TYPE_avqsize_get`) = c("SWIGFunction", class('NODE_TYPE_avqsize_get'))

# Start of new_NODE_TYPE

`NODE_TYPE` = function()
{
  ans = .Call('R_swig_new_NODE_TYPE', PACKAGE='pdq')
  class(ans) <- "_p_NODE_TYPE"
  
  ans
  
}

attr(`NODE_TYPE`, 'returnType') = '_p_NODE_TYPE'
class(`NODE_TYPE`) = c("SWIGFunction", class('NODE_TYPE'))

# Start of delete_NODE_TYPE

`delete_NODE_TYPE` = function(self)
{
  self = coerceIfNotSubclass(self, "_p_NODE_TYPE") 
  .Call('R_swig_delete_NODE_TYPE', self, PACKAGE='pdq')
  
}

attr(`delete_NODE_TYPE`, 'returnType') = 'void'
attr(`delete_NODE_TYPE`, "inputTypes") = c('_p_NODE_TYPE')
class(`delete_NODE_TYPE`) = c("SWIGFunction", class('delete_NODE_TYPE'))

# Start of accessor method for NODE_TYPE
setMethod('$', '_p_NODE_TYPE', function(x, name)

{
  accessorFuns = list('devtype' = NODE_TYPE_devtype_get, 'sched' = NODE_TYPE_sched_get, 'devname' = NODE_TYPE_devname_get, 'visits' = NODE_TYPE_visits_get, 'service' = NODE_TYPE_service_get, 'demand' = NODE_TYPE_demand_get, 'resit' = NODE_TYPE_resit_get, 'utiliz' = NODE_TYPE_utiliz_get, 'qsize' = NODE_TYPE_qsize_get, 'avqsize' = NODE_TYPE_avqsize_get)
  vaccessors = c('devtype', 'sched', 'devname', 'visits', 'service', 'demand', 'resit', 'utiliz', 'qsize', 'avqsize')
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name))
  f = accessorFuns[[idx]]
  formals(f)[[1]] = x
  if (is.na(match(name, vaccessors))) f else f(x)
}


)
# end of accessor method for NODE_TYPE
# Start of accessor method for NODE_TYPE
setMethod('$<-', '_p_NODE_TYPE', function(x, name, value)

{
  accessorFuns = list('devtype' = NODE_TYPE_devtype_set, 'sched' = NODE_TYPE_sched_set, 'devname' = NODE_TYPE_devname_set, 'visits' = NODE_TYPE_visits_set, 'service' = NODE_TYPE_service_set, 'demand' = NODE_TYPE_demand_set, 'resit' = NODE_TYPE_resit_set, 'utiliz' = NODE_TYPE_utiliz_set, 'qsize' = NODE_TYPE_qsize_set, 'avqsize' = NODE_TYPE_avqsize_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
setMethod('[[<-', c('_p_NODE_TYPE', 'character'),function(x, i, j, ..., value)

{
  name = i
  accessorFuns = list('devtype' = NODE_TYPE_devtype_set, 'sched' = NODE_TYPE_sched_set, 'devname' = NODE_TYPE_devname_set, 'visits' = NODE_TYPE_visits_set, 'service' = NODE_TYPE_service_set, 'demand' = NODE_TYPE_demand_set, 'resit' = NODE_TYPE_resit_set, 'utiliz' = NODE_TYPE_utiliz_set, 'qsize' = NODE_TYPE_qsize_set, 'avqsize' = NODE_TYPE_avqsize_set)
  idx = pmatch(name, names(accessorFuns))
  if(is.na(idx)) 
  return(callNextMethod(x, name, value))
  f = accessorFuns[[idx]]
  f(x, value)
  x
}


)
# end of accessor method for NODE_TYPE
setMethod('delete', '_p_NODE_TYPE', function(obj) {delete_NODE_TYPE(obj)})
# Start definition of copy functions & methods for NODE_TYPE
CopyToR_NODE_TYPE = function(value, obj = new("NODE_TYPE"))
{
  obj@devtype = value$devtype
  obj@sched = value$sched
  obj@devname = value$devname
  obj@visits = value$visits
  obj@service = value$service
  obj@demand = value$demand
  obj@resit = value$resit
  obj@utiliz = value$utiliz
  obj@qsize = value$qsize
  obj@avqsize = value$avqsize
  obj
}



CopyToC_NODE_TYPE = function(value, obj)
{
  obj$devtype = value@devtype
  obj$sched = value@sched
  obj$devname = value@devname
  obj$visits = value@visits
  obj$service = value@service
  obj$demand = value@demand
  obj$resit = value@resit
  obj$utiliz = value@utiliz
  obj$qsize = value@qsize
  obj$avqsize = value@avqsize
  obj
}



# Start definition of copy methods for NODE_TYPE
setMethod('copyToR', '_p_NODE_TYPE', CopyToR_NODE_TYPE)
setMethod('copyToC', 'NODE_TYPE', CopyToC_NODE_TYPE)

# End definition of copy methods for NODE_TYPE
# End definition of copy functions & methods for NODE_TYPE
# Start of CreateClosed

`CreateClosed` = function(name, should_be_class, pop, think, .copy = FALSE)
{
  name = as(name, "character") 
  should_be_class = as.integer(should_be_class) 
  
  if(length(should_be_class) > 1) {
    Rf_warning("using only the first element of should_be_class")
  }
  
  pop = as.numeric(pop) 
  think = as.numeric(think) 
  .Call('R_swig_CreateClosed', name, should_be_class, pop, think, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`CreateClosed`, 'returnType') = 'numeric'
attr(`CreateClosed`, "inputTypes") = c('character', 'numeric', 'numeric', 'numeric')
class(`CreateClosed`) = c("SWIGFunction", class('CreateClosed'))

# Start of CreateClosed_p

`CreateClosed_p` = function(name, should_be_class, pop, think, .copy = FALSE)
{
  name = as(name, "character") 
  should_be_class = as.integer(should_be_class) 
  
  if(length(should_be_class) > 1) {
    Rf_warning("using only the first element of should_be_class")
  }
  
  pop = as.numeric(pop) 
  think = as.numeric(think) 
  .Call('R_swig_CreateClosed_p', name, should_be_class, pop, think, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`CreateClosed_p`, 'returnType') = 'numeric'
attr(`CreateClosed_p`, "inputTypes") = c('character', 'numeric', 'numeric', 'numeric')
class(`CreateClosed_p`) = c("SWIGFunction", class('CreateClosed_p'))

# Start of CreateOpen

`CreateOpen` = function(name, lambda, .copy = FALSE)
{
  name = as(name, "character") 
  lambda = as.numeric(lambda) 
  .Call('R_swig_CreateOpen', name, lambda, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`CreateOpen`, 'returnType') = 'numeric'
attr(`CreateOpen`, "inputTypes") = c('character', 'numeric')
class(`CreateOpen`) = c("SWIGFunction", class('CreateOpen'))

# Start of CreateOpen_p

`CreateOpen_p` = function(name, lambda, .copy = FALSE)
{
  name = as(name, "character") 
  lambda = as.numeric(lambda) 
  .Call('R_swig_CreateOpen_p', name, lambda, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`CreateOpen_p`, 'returnType') = 'numeric'
attr(`CreateOpen_p`, "inputTypes") = c('character', 'numeric')
class(`CreateOpen_p`) = c("SWIGFunction", class('CreateOpen_p'))

# Start of CreateNode

`CreateNode` = function(name, device, sched, .copy = FALSE)
{
  name = as(name, "character") 
  device = as.integer(device) 
  
  if(length(device) > 1) {
    Rf_warning("using only the first element of device")
  }
  
  sched = as.integer(sched) 
  
  if(length(sched) > 1) {
    Rf_warning("using only the first element of sched")
  }
  
  .Call('R_swig_CreateNode', name, device, sched, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`CreateNode`, 'returnType') = 'numeric'
attr(`CreateNode`, "inputTypes") = c('character', 'numeric', 'numeric')
class(`CreateNode`) = c("SWIGFunction", class('CreateNode'))

# Start of CreateMultiNode

`CreateMultiNode` = function(servers, name, device, sched, .copy = FALSE)
{
  servers = as.integer(servers) 
  
  if(length(servers) > 1) {
    Rf_warning("using only the first element of servers")
  }
  
  name = as(name, "character") 
  device = as.integer(device) 
  
  if(length(device) > 1) {
    Rf_warning("using only the first element of device")
  }
  
  sched = as.integer(sched) 
  
  if(length(sched) > 1) {
    Rf_warning("using only the first element of sched")
  }
  
  .Call('R_swig_CreateMultiNode', servers, name, device, sched, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`CreateMultiNode`, 'returnType') = 'numeric'
attr(`CreateMultiNode`, "inputTypes") = c('numeric', 'character', 'numeric', 'numeric')
class(`CreateMultiNode`) = c("SWIGFunction", class('CreateMultiNode'))

# Start of GetStreamsCount

`GetStreamsCount` = function(.copy = FALSE)
{
  .Call('R_swig_GetStreamsCount', as.logical(.copy), PACKAGE='pdq')
  
}

attr(`GetStreamsCount`, 'returnType') = 'numeric'
class(`GetStreamsCount`) = c("SWIGFunction", class('GetStreamsCount'))

# Start of GetNodesCount

`GetNodesCount` = function(.copy = FALSE)
{
  .Call('R_swig_GetNodesCount', as.logical(.copy), PACKAGE='pdq')
  
}

attr(`GetNodesCount`, 'returnType') = 'numeric'
class(`GetNodesCount`) = c("SWIGFunction", class('GetNodesCount'))

# Start of GetResponse

`GetResponse` = function(should_be_class, wname, .copy = FALSE)
{
  should_be_class = as.integer(should_be_class) 
  
  if(length(should_be_class) > 1) {
    Rf_warning("using only the first element of should_be_class")
  }
  
  wname = as(wname, "character") 
  .Call('R_swig_GetResponse', should_be_class, wname, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`GetResponse`, 'returnType') = 'numeric'
attr(`GetResponse`, "inputTypes") = c('numeric', 'character')
class(`GetResponse`) = c("SWIGFunction", class('GetResponse'))

# Start of PDQ_GetResidenceTime

`PDQ_GetResidenceTime` = function(device, work, should_be_class, .copy = FALSE)
{
  device = as(device, "character") 
  work = as(work, "character") 
  should_be_class = as.integer(should_be_class) 
  
  if(length(should_be_class) > 1) {
    Rf_warning("using only the first element of should_be_class")
  }
  
  .Call('R_swig_PDQ_GetResidenceTime', device, work, should_be_class, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`PDQ_GetResidenceTime`, 'returnType') = 'numeric'
attr(`PDQ_GetResidenceTime`, "inputTypes") = c('character', 'character', 'numeric')
class(`PDQ_GetResidenceTime`) = c("SWIGFunction", class('PDQ_GetResidenceTime'))

# Start of GetThruput

`GetThruput` = function(should_be_class, wname, .copy = FALSE)
{
  should_be_class = as.integer(should_be_class) 
  
  if(length(should_be_class) > 1) {
    Rf_warning("using only the first element of should_be_class")
  }
  
  wname = as(wname, "character") 
  .Call('R_swig_GetThruput', should_be_class, wname, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`GetThruput`, 'returnType') = 'numeric'
attr(`GetThruput`, "inputTypes") = c('numeric', 'character')
class(`GetThruput`) = c("SWIGFunction", class('GetThruput'))

# Start of PDQ_GetLoadOpt

`PDQ_GetLoadOpt` = function(should_be_class, wname, .copy = FALSE)
{
  should_be_class = as.integer(should_be_class) 
  
  if(length(should_be_class) > 1) {
    Rf_warning("using only the first element of should_be_class")
  }
  
  wname = as(wname, "character") 
  .Call('R_swig_PDQ_GetLoadOpt', should_be_class, wname, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`PDQ_GetLoadOpt`, 'returnType') = 'numeric'
attr(`PDQ_GetLoadOpt`, "inputTypes") = c('numeric', 'character')
class(`PDQ_GetLoadOpt`) = c("SWIGFunction", class('PDQ_GetLoadOpt'))

# Start of GetUtilization

`GetUtilization` = function(device, work, should_be_class, .copy = FALSE)
{
  device = as(device, "character") 
  work = as(work, "character") 
  should_be_class = as.integer(should_be_class) 
  
  if(length(should_be_class) > 1) {
    Rf_warning("using only the first element of should_be_class")
  }
  
  .Call('R_swig_GetUtilization', device, work, should_be_class, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`GetUtilization`, 'returnType') = 'numeric'
attr(`GetUtilization`, "inputTypes") = c('character', 'character', 'numeric')
class(`GetUtilization`) = c("SWIGFunction", class('GetUtilization'))

# Start of GetQueueLength

`GetQueueLength` = function(device, work, should_be_class, .copy = FALSE)
{
  device = as(device, "character") 
  work = as(work, "character") 
  should_be_class = as.integer(should_be_class) 
  
  if(length(should_be_class) > 1) {
    Rf_warning("using only the first element of should_be_class")
  }
  
  .Call('R_swig_GetQueueLength', device, work, should_be_class, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`GetQueueLength`, 'returnType') = 'numeric'
attr(`GetQueueLength`, "inputTypes") = c('character', 'character', 'numeric')
class(`GetQueueLength`) = c("SWIGFunction", class('GetQueueLength'))

# Start of PDQ_GetThruMax

`PDQ_GetThruMax` = function(should_be_class, wname, .copy = FALSE)
{
  should_be_class = as.integer(should_be_class) 
  
  if(length(should_be_class) > 1) {
    Rf_warning("using only the first element of should_be_class")
  }
  
  wname = as(wname, "character") 
  .Call('R_swig_PDQ_GetThruMax', should_be_class, wname, as.logical(.copy), PACKAGE='pdq')
  
}

attr(`PDQ_GetThruMax`, 'returnType') = 'numeric'
attr(`PDQ_GetThruMax`, "inputTypes") = c('numeric', 'character')
class(`PDQ_GetThruMax`) = c("SWIGFunction", class('PDQ_GetThruMax'))

# Start of Init

`Init` = function(name)
{
  name = as(name, "character") 
  .Call('R_swig_Init', name, PACKAGE='pdq')
  
}

attr(`Init`, 'returnType') = 'void'
attr(`Init`, "inputTypes") = c('character')
class(`Init`) = c("SWIGFunction", class('Init'))

# Start of Report

`Report` = function()
{
  .Call('R_swig_Report', PACKAGE='pdq')
  
}

attr(`Report`, 'returnType') = 'void'
class(`Report`) = c("SWIGFunction", class('Report'))

# Start of SetDebug

`SetDebug` = function(flag)
{
  flag = as.integer(flag) 
  
  if(length(flag) > 1) {
    Rf_warning("using only the first element of flag")
  }
  
  .Call('R_swig_SetDebug', flag, PACKAGE='pdq')
  
}

attr(`SetDebug`, 'returnType') = 'void'
attr(`SetDebug`, "inputTypes") = c('numeric')
class(`SetDebug`) = c("SWIGFunction", class('SetDebug'))

# Start of SetDemand

`SetDemand` = function(nodename, workname, time)
{
  nodename = as(nodename, "character") 
  workname = as(workname, "character") 
  time = as.numeric(time) 
  .Call('R_swig_SetDemand', nodename, workname, time, PACKAGE='pdq')
  
}

attr(`SetDemand`, 'returnType') = 'void'
attr(`SetDemand`, "inputTypes") = c('character', 'character', 'numeric')
class(`SetDemand`) = c("SWIGFunction", class('SetDemand'))

# Start of SetDemand_p

`SetDemand_p` = function(nodename, workname, time)
{
  nodename = as(nodename, "character") 
  workname = as(workname, "character") 
  time = as.numeric(time) 
  .Call('R_swig_SetDemand_p', nodename, workname, time, PACKAGE='pdq')
  
}

attr(`SetDemand_p`, 'returnType') = 'void'
attr(`SetDemand_p`, "inputTypes") = c('character', 'character', 'numeric')
class(`SetDemand_p`) = c("SWIGFunction", class('SetDemand_p'))

# Start of SetVisits

`SetVisits` = function(nodename, workname, visits, service)
{
  nodename = as(nodename, "character") 
  workname = as(workname, "character") 
  visits = as.numeric(visits) 
  service = as.numeric(service) 
  .Call('R_swig_SetVisits', nodename, workname, visits, service, PACKAGE='pdq')
  
}

attr(`SetVisits`, 'returnType') = 'void'
attr(`SetVisits`, "inputTypes") = c('character', 'character', 'numeric', 'numeric')
class(`SetVisits`) = c("SWIGFunction", class('SetVisits'))

# Start of SetVisits_p

`SetVisits_p` = function(nodename, workname, visits, service)
{
  nodename = as(nodename, "character") 
  workname = as(workname, "character") 
  visits = as.numeric(visits) 
  service = as.numeric(service) 
  .Call('R_swig_SetVisits_p', nodename, workname, visits, service, PACKAGE='pdq')
  
}

attr(`SetVisits_p`, 'returnType') = 'void'
attr(`SetVisits_p`, "inputTypes") = c('character', 'character', 'numeric', 'numeric')
class(`SetVisits_p`) = c("SWIGFunction", class('SetVisits_p'))

# Start of Solve

`Solve` = function(method)
{
  method = as.integer(method) 
  
  if(length(method) > 1) {
    Rf_warning("using only the first element of method")
  }
  
  .Call('R_swig_Solve', method, PACKAGE='pdq')
  
}

attr(`Solve`, 'returnType') = 'void'
attr(`Solve`, "inputTypes") = c('numeric')
class(`Solve`) = c("SWIGFunction", class('Solve'))

# Start of SetWUnit

`SetWUnit` = function(unitName)
{
  unitName = as(unitName, "character") 
  .Call('R_swig_SetWUnit', unitName, PACKAGE='pdq')
  
}

attr(`SetWUnit`, 'returnType') = 'void'
attr(`SetWUnit`, "inputTypes") = c('character')
class(`SetWUnit`) = c("SWIGFunction", class('SetWUnit'))

# Start of SetTUnit

`SetTUnit` = function(unitName)
{
  unitName = as(unitName, "character") 
  .Call('R_swig_SetTUnit', unitName, PACKAGE='pdq')
  
}

attr(`SetTUnit`, 'returnType') = 'void'
attr(`SetTUnit`, "inputTypes") = c('character')
class(`SetTUnit`) = c("SWIGFunction", class('SetTUnit'))

# Start of SetComment

`SetComment` = function(comment)
{
  comment = as(comment, "character") 
  .Call('R_swig_SetComment', comment, PACKAGE='pdq')
  
}

attr(`SetComment`, 'returnType') = 'void'
attr(`SetComment`, "inputTypes") = c('character')
class(`SetComment`) = c("SWIGFunction", class('SetComment'))

# Start of GetComment

`GetComment` = function()
{
  .Call('R_swig_GetComment', PACKAGE='pdq')
  
}

attr(`GetComment`, 'returnType') = 'character'
class(`GetComment`) = c("SWIGFunction", class('GetComment'))

# Start of PrintNodes

`PrintNodes` = function()
{
  .Call('R_swig_PrintNodes', PACKAGE='pdq')
  
}

attr(`PrintNodes`, 'returnType') = 'void'
class(`PrintNodes`) = c("SWIGFunction", class('PrintNodes'))

# Start of GetNode

`GetNode` = function(idx)
{
  idx = as.integer(idx) 
  
  if(length(idx) > 1) {
    Rf_warning("using only the first element of idx")
  }
  
  ans = .Call('R_swig_GetNode', idx, PACKAGE='pdq')
  class(ans) <- "_p_NODE_TYPE"
  
  ans
  
}

attr(`GetNode`, 'returnType') = '_p_NODE_TYPE'
attr(`GetNode`, "inputTypes") = c('numeric')
class(`GetNode`) = c("SWIGFunction", class('GetNode'))

# Start of getjob

`getjob` = function(idx)
{
  idx = as.integer(idx) 
  
  if(length(idx) > 1) {
    Rf_warning("using only the first element of idx")
  }
  
  ans = .Call('R_swig_getjob', idx, PACKAGE='pdq')
  class(ans) <- "_p_JOB_TYPE"
  
  ans
  
}

attr(`getjob`, 'returnType') = '_p_JOB_TYPE'
attr(`getjob`, "inputTypes") = c('numeric')
class(`getjob`) = c("SWIGFunction", class('getjob'))

# Start of nodes_set

`nodes_set` = function(s_nodes)
{
  s_nodes = as.integer(s_nodes) 
  
  if(length(s_nodes) > 1) {
    Rf_warning("using only the first element of s_nodes")
  }
  
  .Call('R_swig_nodes_set', s_nodes, PACKAGE='pdq')
  
}

attr(`nodes_set`, 'returnType') = 'void'
attr(`nodes_set`, "inputTypes") = c('numeric')
class(`nodes_set`) = c("SWIGFunction", class('nodes_set'))

# Start of nodes_get

`nodes_get` = function(.copy = FALSE)
{
  .Call('R_swig_nodes_get', as.logical(.copy), PACKAGE='pdq')
  
}

attr(`nodes_get`, 'returnType') = 'numeric'
class(`nodes_get`) = c("SWIGFunction", class('nodes_get'))

nodes = 
function(value, .copy = FALSE)
{
  if(missing(value)) {
    nodes_get(.copy)
  } else {
    nodes_set(value)
  }
}

# Start of streams_set

`streams_set` = function(s_streams)
{
  s_streams = as.integer(s_streams) 
  
  if(length(s_streams) > 1) {
    Rf_warning("using only the first element of s_streams")
  }
  
  .Call('R_swig_streams_set', s_streams, PACKAGE='pdq')
  
}

attr(`streams_set`, 'returnType') = 'void'
attr(`streams_set`, "inputTypes") = c('numeric')
class(`streams_set`) = c("SWIGFunction", class('streams_set'))

# Start of streams_get

`streams_get` = function(.copy = FALSE)
{
  .Call('R_swig_streams_get', as.logical(.copy), PACKAGE='pdq')
  
}

attr(`streams_get`, 'returnType') = 'numeric'
class(`streams_get`) = c("SWIGFunction", class('streams_get'))

streams = 
function(value, .copy = FALSE)
{
  if(missing(value)) {
    streams_get(.copy)
  } else {
    streams_set(value)
  }
}

# Start of node_set

`node_set` = function(s_node)
{
  s_node = coerceIfNotSubclass(s_node, "_p_NODE_TYPE") 
  .Call('R_swig_node_set', s_node, PACKAGE='pdq')
  
}

attr(`node_set`, 'returnType') = 'void'
attr(`node_set`, "inputTypes") = c('_p_NODE_TYPE')
class(`node_set`) = c("SWIGFunction", class('node_set'))

# Start of node_get

`node_get` = function()
{
  ans = .Call('R_swig_node_get', PACKAGE='pdq')
  class(ans) <- "_p_NODE_TYPE"
  
  ans
  
}

attr(`node_get`, 'returnType') = '_p_NODE_TYPE'
class(`node_get`) = c("SWIGFunction", class('node_get'))

node = 
function(value)
{
  if(missing(value)) {
    node_get()
  } else {
    node_set(value)
  }
}

# Start of job_set

`job_set` = function(s_job)
{
  s_job = coerceIfNotSubclass(s_job, "_p_JOB_TYPE") 
  .Call('R_swig_job_set', s_job, PACKAGE='pdq')
  
}

attr(`job_set`, 'returnType') = 'void'
attr(`job_set`, "inputTypes") = c('_p_JOB_TYPE')
class(`job_set`) = c("SWIGFunction", class('job_set'))

# Start of job_get

`job_get` = function()
{
  ans = .Call('R_swig_job_get', PACKAGE='pdq')
  class(ans) <- "_p_JOB_TYPE"
  
  ans
  
}

attr(`job_get`, 'returnType') = '_p_JOB_TYPE'
class(`job_get`) = c("SWIGFunction", class('job_get'))

job = 
function(value)
{
  if(missing(value)) {
    job_get()
  } else {
    job_set(value)
  }
}

# Start of Comment_set

`Comment_set` = function(s_Comment)
{
  s_Comment = coerceIfNotSubclass(s_Comment, "_p_char") 
  .Call('R_swig_Comment_set', s_Comment, PACKAGE='pdq')
  
}

attr(`Comment_set`, 'returnType') = 'void'
attr(`Comment_set`, "inputTypes") = c('_p_char')
class(`Comment_set`) = c("SWIGFunction", class('Comment_set'))

# Start of Comment_get

`Comment_get` = function(.copy = FALSE)
{
  ans = .Call('R_swig_Comment_get', as.logical(.copy), PACKAGE='pdq')
  class(ans) <- "_p_char"
  
  ans
  
}

attr(`Comment_get`, 'returnType') = '_p_char'
class(`Comment_get`) = c("SWIGFunction", class('Comment_get'))

Comment = 
function(value, .copy = FALSE)
{
  if(missing(value)) {
    Comment_get(.copy)
  } else {
    Comment_set(value)
  }
}


