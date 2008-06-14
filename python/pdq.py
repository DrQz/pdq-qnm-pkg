# This file was created automatically by SWIG 1.3.29.
# Don't modify this file, modify the SWIG interface instead.
# This file is compatible with both classic and new-style classes.

import _pdq
import new
new_instancemethod = new.instancemethod
def _swig_setattr_nondynamic(self,class_type,name,value,static=1):
    if (name == "thisown"): return self.this.own(value)
    if (name == "this"):
        if type(value).__name__ == 'PySwigObject':
            self.__dict__[name] = value
            return
    method = class_type.__swig_setmethods__.get(name,None)
    if method: return method(self,value)
    if (not static) or hasattr(self,name):
        self.__dict__[name] = value
    else:
        raise AttributeError("You cannot add attributes to %s" % self)

def _swig_setattr(self,class_type,name,value):
    return _swig_setattr_nondynamic(self,class_type,name,value,0)

def _swig_getattr(self,class_type,name):
    if (name == "thisown"): return self.this.own()
    method = class_type.__swig_getmethods__.get(name,None)
    if method: return method(self)
    raise AttributeError,name

def _swig_repr(self):
    try: strthis = "proxy of " + self.this.__repr__()
    except: strthis = ""
    return "<%s.%s; %s >" % (self.__class__.__module__, self.__class__.__name__, strthis,)

import types
try:
    _object = types.ObjectType
    _newclass = 1
except AttributeError:
    class _object : pass
    _newclass = 0
del types


TRUE = _pdq.TRUE
FALSE = _pdq.FALSE
MAXNODES = _pdq.MAXNODES
MAXBUF = _pdq.MAXBUF
MAXSTREAMS = _pdq.MAXSTREAMS
MAXCHARS = _pdq.MAXCHARS
VOID = _pdq.VOID
OPEN = _pdq.OPEN
CLOSED = _pdq.CLOSED
MEM = _pdq.MEM
CEN = _pdq.CEN
DLY = _pdq.DLY
MSQ = _pdq.MSQ
ISRV = _pdq.ISRV
FCFS = _pdq.FCFS
PSHR = _pdq.PSHR
LCFS = _pdq.LCFS
TERM = _pdq.TERM
TRANS = _pdq.TRANS
BATCH = _pdq.BATCH
EXACT = _pdq.EXACT
APPROX = _pdq.APPROX
CANON = _pdq.CANON
VISITS = _pdq.VISITS
DEMAND = _pdq.DEMAND
PDQ_SP = _pdq.PDQ_SP
PDQ_MP = _pdq.PDQ_MP
TOL = _pdq.TOL
class SYSTAT_TYPE(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, SYSTAT_TYPE, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, SYSTAT_TYPE, name)
    __repr__ = _swig_repr
    __swig_setmethods__["response"] = _pdq.SYSTAT_TYPE_response_set
    __swig_getmethods__["response"] = _pdq.SYSTAT_TYPE_response_get
    if _newclass:response = property(_pdq.SYSTAT_TYPE_response_get, _pdq.SYSTAT_TYPE_response_set)
    __swig_setmethods__["thruput"] = _pdq.SYSTAT_TYPE_thruput_set
    __swig_getmethods__["thruput"] = _pdq.SYSTAT_TYPE_thruput_get
    if _newclass:thruput = property(_pdq.SYSTAT_TYPE_thruput_get, _pdq.SYSTAT_TYPE_thruput_set)
    __swig_setmethods__["residency"] = _pdq.SYSTAT_TYPE_residency_set
    __swig_getmethods__["residency"] = _pdq.SYSTAT_TYPE_residency_get
    if _newclass:residency = property(_pdq.SYSTAT_TYPE_residency_get, _pdq.SYSTAT_TYPE_residency_set)
    __swig_setmethods__["physmem"] = _pdq.SYSTAT_TYPE_physmem_set
    __swig_getmethods__["physmem"] = _pdq.SYSTAT_TYPE_physmem_get
    if _newclass:physmem = property(_pdq.SYSTAT_TYPE_physmem_get, _pdq.SYSTAT_TYPE_physmem_set)
    __swig_setmethods__["highwater"] = _pdq.SYSTAT_TYPE_highwater_set
    __swig_getmethods__["highwater"] = _pdq.SYSTAT_TYPE_highwater_get
    if _newclass:highwater = property(_pdq.SYSTAT_TYPE_highwater_get, _pdq.SYSTAT_TYPE_highwater_set)
    __swig_setmethods__["malloc"] = _pdq.SYSTAT_TYPE_malloc_set
    __swig_getmethods__["malloc"] = _pdq.SYSTAT_TYPE_malloc_get
    if _newclass:malloc = property(_pdq.SYSTAT_TYPE_malloc_get, _pdq.SYSTAT_TYPE_malloc_set)
    __swig_setmethods__["mpl"] = _pdq.SYSTAT_TYPE_mpl_set
    __swig_getmethods__["mpl"] = _pdq.SYSTAT_TYPE_mpl_get
    if _newclass:mpl = property(_pdq.SYSTAT_TYPE_mpl_get, _pdq.SYSTAT_TYPE_mpl_set)
    __swig_setmethods__["maxN"] = _pdq.SYSTAT_TYPE_maxN_set
    __swig_getmethods__["maxN"] = _pdq.SYSTAT_TYPE_maxN_get
    if _newclass:maxN = property(_pdq.SYSTAT_TYPE_maxN_get, _pdq.SYSTAT_TYPE_maxN_set)
    __swig_setmethods__["maxTP"] = _pdq.SYSTAT_TYPE_maxTP_set
    __swig_getmethods__["maxTP"] = _pdq.SYSTAT_TYPE_maxTP_get
    if _newclass:maxTP = property(_pdq.SYSTAT_TYPE_maxTP_get, _pdq.SYSTAT_TYPE_maxTP_set)
    __swig_setmethods__["minRT"] = _pdq.SYSTAT_TYPE_minRT_set
    __swig_getmethods__["minRT"] = _pdq.SYSTAT_TYPE_minRT_get
    if _newclass:minRT = property(_pdq.SYSTAT_TYPE_minRT_get, _pdq.SYSTAT_TYPE_minRT_set)
    def __init__(self, *args): 
        this = _pdq.new_SYSTAT_TYPE(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _pdq.delete_SYSTAT_TYPE
    __del__ = lambda self : None;
SYSTAT_TYPE_swigregister = _pdq.SYSTAT_TYPE_swigregister
SYSTAT_TYPE_swigregister(SYSTAT_TYPE)
cvar = _pdq.cvar

class TERMINAL_TYPE(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, TERMINAL_TYPE, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, TERMINAL_TYPE, name)
    __repr__ = _swig_repr
    __swig_setmethods__["name"] = _pdq.TERMINAL_TYPE_name_set
    __swig_getmethods__["name"] = _pdq.TERMINAL_TYPE_name_get
    if _newclass:name = property(_pdq.TERMINAL_TYPE_name_get, _pdq.TERMINAL_TYPE_name_set)
    __swig_setmethods__["pop"] = _pdq.TERMINAL_TYPE_pop_set
    __swig_getmethods__["pop"] = _pdq.TERMINAL_TYPE_pop_get
    if _newclass:pop = property(_pdq.TERMINAL_TYPE_pop_get, _pdq.TERMINAL_TYPE_pop_set)
    __swig_setmethods__["think"] = _pdq.TERMINAL_TYPE_think_set
    __swig_getmethods__["think"] = _pdq.TERMINAL_TYPE_think_get
    if _newclass:think = property(_pdq.TERMINAL_TYPE_think_get, _pdq.TERMINAL_TYPE_think_set)
    __swig_setmethods__["sys"] = _pdq.TERMINAL_TYPE_sys_set
    __swig_getmethods__["sys"] = _pdq.TERMINAL_TYPE_sys_get
    if _newclass:sys = property(_pdq.TERMINAL_TYPE_sys_get, _pdq.TERMINAL_TYPE_sys_set)
    def __init__(self, *args): 
        this = _pdq.new_TERMINAL_TYPE(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _pdq.delete_TERMINAL_TYPE
    __del__ = lambda self : None;
TERMINAL_TYPE_swigregister = _pdq.TERMINAL_TYPE_swigregister
TERMINAL_TYPE_swigregister(TERMINAL_TYPE)

class BATCH_TYPE(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, BATCH_TYPE, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, BATCH_TYPE, name)
    __repr__ = _swig_repr
    __swig_setmethods__["name"] = _pdq.BATCH_TYPE_name_set
    __swig_getmethods__["name"] = _pdq.BATCH_TYPE_name_get
    if _newclass:name = property(_pdq.BATCH_TYPE_name_get, _pdq.BATCH_TYPE_name_set)
    __swig_setmethods__["pop"] = _pdq.BATCH_TYPE_pop_set
    __swig_getmethods__["pop"] = _pdq.BATCH_TYPE_pop_get
    if _newclass:pop = property(_pdq.BATCH_TYPE_pop_get, _pdq.BATCH_TYPE_pop_set)
    __swig_setmethods__["sys"] = _pdq.BATCH_TYPE_sys_set
    __swig_getmethods__["sys"] = _pdq.BATCH_TYPE_sys_get
    if _newclass:sys = property(_pdq.BATCH_TYPE_sys_get, _pdq.BATCH_TYPE_sys_set)
    def __init__(self, *args): 
        this = _pdq.new_BATCH_TYPE(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _pdq.delete_BATCH_TYPE
    __del__ = lambda self : None;
BATCH_TYPE_swigregister = _pdq.BATCH_TYPE_swigregister
BATCH_TYPE_swigregister(BATCH_TYPE)

class TRANSACTION_TYPE(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, TRANSACTION_TYPE, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, TRANSACTION_TYPE, name)
    __repr__ = _swig_repr
    __swig_setmethods__["name"] = _pdq.TRANSACTION_TYPE_name_set
    __swig_getmethods__["name"] = _pdq.TRANSACTION_TYPE_name_get
    if _newclass:name = property(_pdq.TRANSACTION_TYPE_name_get, _pdq.TRANSACTION_TYPE_name_set)
    __swig_setmethods__["arrival_rate"] = _pdq.TRANSACTION_TYPE_arrival_rate_set
    __swig_getmethods__["arrival_rate"] = _pdq.TRANSACTION_TYPE_arrival_rate_get
    if _newclass:arrival_rate = property(_pdq.TRANSACTION_TYPE_arrival_rate_get, _pdq.TRANSACTION_TYPE_arrival_rate_set)
    __swig_setmethods__["saturation_rate"] = _pdq.TRANSACTION_TYPE_saturation_rate_set
    __swig_getmethods__["saturation_rate"] = _pdq.TRANSACTION_TYPE_saturation_rate_get
    if _newclass:saturation_rate = property(_pdq.TRANSACTION_TYPE_saturation_rate_get, _pdq.TRANSACTION_TYPE_saturation_rate_set)
    __swig_setmethods__["sys"] = _pdq.TRANSACTION_TYPE_sys_set
    __swig_getmethods__["sys"] = _pdq.TRANSACTION_TYPE_sys_get
    if _newclass:sys = property(_pdq.TRANSACTION_TYPE_sys_get, _pdq.TRANSACTION_TYPE_sys_set)
    def __init__(self, *args): 
        this = _pdq.new_TRANSACTION_TYPE(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _pdq.delete_TRANSACTION_TYPE
    __del__ = lambda self : None;
TRANSACTION_TYPE_swigregister = _pdq.TRANSACTION_TYPE_swigregister
TRANSACTION_TYPE_swigregister(TRANSACTION_TYPE)

class JOB_TYPE(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, JOB_TYPE, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, JOB_TYPE, name)
    __repr__ = _swig_repr
    __swig_setmethods__["should_be_class"] = _pdq.JOB_TYPE_should_be_class_set
    __swig_getmethods__["should_be_class"] = _pdq.JOB_TYPE_should_be_class_get
    if _newclass:should_be_class = property(_pdq.JOB_TYPE_should_be_class_get, _pdq.JOB_TYPE_should_be_class_set)
    __swig_setmethods__["network"] = _pdq.JOB_TYPE_network_set
    __swig_getmethods__["network"] = _pdq.JOB_TYPE_network_get
    if _newclass:network = property(_pdq.JOB_TYPE_network_get, _pdq.JOB_TYPE_network_set)
    __swig_setmethods__["term"] = _pdq.JOB_TYPE_term_set
    __swig_getmethods__["term"] = _pdq.JOB_TYPE_term_get
    if _newclass:term = property(_pdq.JOB_TYPE_term_get, _pdq.JOB_TYPE_term_set)
    __swig_setmethods__["batch"] = _pdq.JOB_TYPE_batch_set
    __swig_getmethods__["batch"] = _pdq.JOB_TYPE_batch_get
    if _newclass:batch = property(_pdq.JOB_TYPE_batch_get, _pdq.JOB_TYPE_batch_set)
    __swig_setmethods__["trans"] = _pdq.JOB_TYPE_trans_set
    __swig_getmethods__["trans"] = _pdq.JOB_TYPE_trans_get
    if _newclass:trans = property(_pdq.JOB_TYPE_trans_get, _pdq.JOB_TYPE_trans_set)
    def __init__(self, *args): 
        this = _pdq.new_JOB_TYPE(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _pdq.delete_JOB_TYPE
    __del__ = lambda self : None;
JOB_TYPE_swigregister = _pdq.JOB_TYPE_swigregister
JOB_TYPE_swigregister(JOB_TYPE)

class NODE_TYPE(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, NODE_TYPE, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, NODE_TYPE, name)
    __repr__ = _swig_repr
    __swig_setmethods__["devtype"] = _pdq.NODE_TYPE_devtype_set
    __swig_getmethods__["devtype"] = _pdq.NODE_TYPE_devtype_get
    if _newclass:devtype = property(_pdq.NODE_TYPE_devtype_get, _pdq.NODE_TYPE_devtype_set)
    __swig_setmethods__["sched"] = _pdq.NODE_TYPE_sched_set
    __swig_getmethods__["sched"] = _pdq.NODE_TYPE_sched_get
    if _newclass:sched = property(_pdq.NODE_TYPE_sched_get, _pdq.NODE_TYPE_sched_set)
    __swig_setmethods__["devname"] = _pdq.NODE_TYPE_devname_set
    __swig_getmethods__["devname"] = _pdq.NODE_TYPE_devname_get
    if _newclass:devname = property(_pdq.NODE_TYPE_devname_get, _pdq.NODE_TYPE_devname_set)
    __swig_setmethods__["visits"] = _pdq.NODE_TYPE_visits_set
    __swig_getmethods__["visits"] = _pdq.NODE_TYPE_visits_get
    if _newclass:visits = property(_pdq.NODE_TYPE_visits_get, _pdq.NODE_TYPE_visits_set)
    __swig_setmethods__["service"] = _pdq.NODE_TYPE_service_set
    __swig_getmethods__["service"] = _pdq.NODE_TYPE_service_get
    if _newclass:service = property(_pdq.NODE_TYPE_service_get, _pdq.NODE_TYPE_service_set)
    __swig_setmethods__["demand"] = _pdq.NODE_TYPE_demand_set
    __swig_getmethods__["demand"] = _pdq.NODE_TYPE_demand_get
    if _newclass:demand = property(_pdq.NODE_TYPE_demand_get, _pdq.NODE_TYPE_demand_set)
    __swig_setmethods__["resit"] = _pdq.NODE_TYPE_resit_set
    __swig_getmethods__["resit"] = _pdq.NODE_TYPE_resit_get
    if _newclass:resit = property(_pdq.NODE_TYPE_resit_get, _pdq.NODE_TYPE_resit_set)
    __swig_setmethods__["utiliz"] = _pdq.NODE_TYPE_utiliz_set
    __swig_getmethods__["utiliz"] = _pdq.NODE_TYPE_utiliz_get
    if _newclass:utiliz = property(_pdq.NODE_TYPE_utiliz_get, _pdq.NODE_TYPE_utiliz_set)
    __swig_setmethods__["qsize"] = _pdq.NODE_TYPE_qsize_set
    __swig_getmethods__["qsize"] = _pdq.NODE_TYPE_qsize_get
    if _newclass:qsize = property(_pdq.NODE_TYPE_qsize_get, _pdq.NODE_TYPE_qsize_set)
    __swig_setmethods__["avqsize"] = _pdq.NODE_TYPE_avqsize_set
    __swig_getmethods__["avqsize"] = _pdq.NODE_TYPE_avqsize_get
    if _newclass:avqsize = property(_pdq.NODE_TYPE_avqsize_get, _pdq.NODE_TYPE_avqsize_set)
    def __init__(self, *args): 
        this = _pdq.new_NODE_TYPE(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _pdq.delete_NODE_TYPE
    __del__ = lambda self : None;
NODE_TYPE_swigregister = _pdq.NODE_TYPE_swigregister
NODE_TYPE_swigregister(NODE_TYPE)

CreateClosed = _pdq.CreateClosed
CreateClosed_p = _pdq.CreateClosed_p
CreateOpen = _pdq.CreateOpen
CreateOpen_p = _pdq.CreateOpen_p
CreateNode = _pdq.CreateNode
GetSteamsCount = _pdq.GetSteamsCount
GetNodesCount = _pdq.GetNodesCount
GetResponse = _pdq.GetResponse
PDQ_GetResidenceTime = _pdq.PDQ_GetResidenceTime
GetThruput = _pdq.GetThruput
PDQ_GetLoadOpt = _pdq.PDQ_GetLoadOpt
GetUtilization = _pdq.GetUtilization
GetQueueLength = _pdq.GetQueueLength
PDQ_GetThruMax = _pdq.PDQ_GetThruMax
Init = _pdq.Init
Report = _pdq.Report
SetDebug = _pdq.SetDebug
SetDemand = _pdq.SetDemand
SetDemand_p = _pdq.SetDemand_p
SetVisits = _pdq.SetVisits
SetVisits_p = _pdq.SetVisits_p
Solve = _pdq.Solve
SetWUnit = _pdq.SetWUnit
SetTUnit = _pdq.SetTUnit
SetComment = _pdq.SetComment
GetComment = _pdq.GetComment
PrintNodes = _pdq.PrintNodes
GetNode = _pdq.GetNode
getjob = _pdq.getjob


