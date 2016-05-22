// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; indent-tabs-mode: nil; -*-
//
// rcpp_module.cpp: Rcpp R/C++ interface class library -- Rcpp Module examples
//
// Copyright (C) 2010 - 2012  Dirk Eddelbuettel and Romain Francois
//
// This file is part of Rcpp.
//
// Rcpp is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// Rcpp is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Rcpp.  If not, see <http://www.gnu.org/licenses/>.

#include <Rcpp.h>

extern "C" {
#include "PDQ_Lib.h"
#include "PDQ_Global.h"
};


void CreateClosed(std::string pdq_name,int should_be_class, double pop, double think) {
    char *name = new char[ pdq_name.size() +1 ];
    std::copy(pdq_name.begin(), pdq_name.end(),name);
    name[pdq_name.size()] = '\0';
    PDQ_CreateClosed(name,should_be_class,pop,think);
    delete[] name;                          
}

void CreateOpen( std::string pdq_name, double lambda ) {
    char *name = new char[ pdq_name.size() +1 ];
    std::copy(pdq_name.begin(), pdq_name.end(),name);
    name[pdq_name.size()] = '\0';
    PDQ_CreateOpen(name,lambda);
    delete[] name;
}

void CreateNode( std::string pdq_name, int device, int sched ) {
    char *name = new char[ pdq_name.size() +1 ];
    std::copy(pdq_name.begin(), pdq_name.end(),name);
    name[pdq_name.size()] = '\0';
    PDQ_CreateNode(name,device,sched);
    delete[] name;
}

void CreateMultiNode(int servers, std::string pdq_name, int device, int sched ) {
    char *name = new char[ pdq_name.size() +1 ];
    std::copy(pdq_name.begin(), pdq_name.end(),name);
    name[pdq_name.size()] = '\0';
    PDQ_CreateMultiNode(servers,name,device,sched);
    delete[] name;
}

int GetStreamsCount(void) {
    return(PDQ_GetStreamsCount());
   
}

int GetNodesCount(void) {
    return(PDQ_GetNodesCount());
}

double GetResponse(int should_be_class, std::string pdq_wname) {
    char *wname = new char[ pdq_wname.size() +1 ];
    double result;
    std::copy(pdq_wname.begin(), pdq_wname.end(),wname);
    wname[pdq_wname.size()] = '\0';
    result = PDQ_GetResponse(should_be_class,wname);
    delete[] wname;                          
    return(result);

}

double GetResidenceTime( std::string pdq_device, std::string pdq_work, int should_be_class ) {
    char *device = new char[ pdq_device.size() +1 ];
    char *work = new char[ pdq_work.size() + 1 ];
    double result;
    std::copy(pdq_device.begin(), pdq_device.end(),device);
    std::copy(pdq_work.begin(), pdq_work.end(),work);
    device[pdq_device.size()] = '\0';
    work[pdq_work.size()] = '\0';
    result = PDQ_GetResidenceTime(device,work,should_be_class);
    delete[] device;
    delete[] work;
    return(result);
}

double GetThruput(int should_be_class, std::string pdq_wname) {
    char *wname = new char[ pdq_wname.size() +1 ];
    double result;
    std::copy(pdq_wname.begin(), pdq_wname.end(),wname);
    wname[pdq_wname.size()] = '\0';
    result = PDQ_GetThruput(should_be_class,wname);
    delete[] wname;                          
    return(result);

}

double GetLoadOpt(int should_be_class, std::string pdq_wname) {
    char *wname = new char[ pdq_wname.size() +1 ];
    double result;
    std::copy(pdq_wname.begin(), pdq_wname.end(),wname);
    wname[pdq_wname.size()] = '\0';
    result = PDQ_GetLoadOpt(should_be_class,wname);
    delete[] wname;                          
    return(result);
}

double GetUtilization( std::string pdq_device, std::string pdq_work, int should_be_class ) {
    char *device = new char[ pdq_device.size() +1 ];
    char *work = new char[ pdq_work.size() + 1 ];
    double result;
    std::copy(pdq_device.begin(), pdq_device.end(),device);
    std::copy(pdq_work.begin(), pdq_work.end(),work);
    device[pdq_device.size()] = '\0';
    work[pdq_work.size()] = '\0';
    result = PDQ_GetUtilization(device,work,should_be_class);
    delete[] device;
    delete[] work;
    return(result);
}

double GetQueueLength( std::string pdq_device, std::string pdq_work, int should_be_class ) {
    char *device = new char[ pdq_device.size() +1 ];
    char *work = new char[ pdq_work.size() + 1 ];
    double result;
    std::copy(pdq_device.begin(), pdq_device.end(),device);
    std::copy(pdq_work.begin(), pdq_work.end(),work);
    device[pdq_device.size()] = '\0';
    work[pdq_work.size()] = '\0';
    result = PDQ_GetQueueLength(device,work,should_be_class);
    delete[] device;
    delete[] work;
    return(result);
}

double GetThruMax(int should_be_class, std::string pdq_wname) {
    char *wname = new char[ pdq_wname.size() +1 ];
    double result;
    std::copy(pdq_wname.begin(), pdq_wname.end(),wname);
    wname[pdq_wname.size()] = '\0';
    result = PDQ_GetThruMax(should_be_class,wname);
    delete[] wname;                          
    return(result);

}

/* double GetTotalDemand(int should_be_class, string pdq_wname) {
    char *wname = new char[ pdq_wname.size() +1 ];
    double result;
    std::copy(pdq_wname.begin(), pdq_wname.end(),wname);
    wname[pdq_wname.size()] = '\0';
    result = PDQ_GetTotalDemand(should_be_class,wname);
    delete[] wname;                          
    return(result);

    } */

void Init( std::string pdq_name ) {
    char *name = new char[ pdq_name.size() +1 ];
    std::copy(pdq_name.begin(), pdq_name.end(),name);
    name[pdq_name.size()] = '\0';
    PDQ_Init(name);
    delete[] name;
}

void Report(void) {
    PDQ_Report();
}


void SetDebug(int flag) {
    PDQ_SetDebug(flag);
}

void SetDemand( std::string pdq_nodename, std::string pdq_workname, double time ) {
    char *nodename = new char[ pdq_nodename.size() +1 ];
    char *workname = new char[ pdq_workname.size() + 1 ];
    std::copy(pdq_nodename.begin(), pdq_nodename.end(),nodename);
    std::copy(pdq_workname.begin(), pdq_workname.end(),workname);
    nodename[pdq_nodename.size()] = '\0';
    workname[pdq_workname.size()] = '\0';
    PDQ_SetDemand(nodename,workname,time);
    delete[] nodename;
    delete[] workname;

}

void SetVisits( std::string pdq_nodename, std::string pdq_workname, double visits,double service) {
    char *nodename = new char[ pdq_nodename.size() +1 ];
    char *workname = new char[ pdq_workname.size() + 1 ];
    std::copy(pdq_nodename.begin(), pdq_nodename.end(),nodename);
    std::copy(pdq_workname.begin(), pdq_workname.end(),workname);
    nodename[pdq_nodename.size()] = '\0';
    workname[pdq_workname.size()] = '\0';
    PDQ_SetVisits(nodename,workname,visits,service);
    delete[] nodename;
    delete[] workname;

}

void Solve(int pdq_method) {
    PDQ_Solve(pdq_method);
}


void SetWUnit( std::string pdq_name ) {
    char *name = new char[ pdq_name.size() +1 ];
    std::copy(pdq_name.begin(), pdq_name.end(),name);
    name[pdq_name.size()] = '\0';
    PDQ_SetWUnit(name);
    delete[] name;
}

void SetTUnit( std::string pdq_name ) {
    char *name = new char[ pdq_name.size() +1 ];
    std::copy(pdq_name.begin(), pdq_name.end(),name);
    name[pdq_name.size()] = '\0';
    PDQ_SetTUnit(name);
    delete[] name;
}

void SetComment( std::string pdq_name ) {
    char *name = new char[ pdq_name.size() +1 ];
    std::copy(pdq_name.begin(), pdq_name.end(),name);
    name[pdq_name.size()] = '\0';
    PDQ_SetComment(name);
    delete[] name;
}


std::string GetComment(void) {
    return(PDQ_GetComment());
}


using namespace Rcpp ;

RCPP_MODULE(pdq){
  
    function( "CreateClosed" , &CreateClosed  , 
              List::create(_["name"],_["class"],_["pop"],_["think"]),
              "documentation for CreateClosed " );
    function( "CreateOpen" , &CreateOpen  , 
              List::create(_["name"],_["lambda"]),
              "documentation for CreateOpen " );
    function( "CreateNode" , &CreateNode  , 
              List::create(_["name"],_["device"],_["sched"]),
                           "documentation for CreateNode " );
    function( "CreateMultiNode" , &CreateMultiNode  , 
              List::create(_["servers"],_["name"],_["device"],_["sched"]),
              "documentation for CreateMultiNode " );
    function( "GetStreamsCount" , &GetStreamsCount  , "documentation for GetStreamsCount " );
    function( "GetNodesCount" , &GetNodesCount  , "documentation for GetNodesCount " );
    function( "GetResponse", &GetResponse, 
              List::create(_["class"],_["wname"]),
              "documentation for GetResponse ");
    function( "GetResidenceTime", &GetResidenceTime, 
              List::create(_["device"],_["work"],_["class"]),
              "documentation for GetResidenceTime ");
    function( "GetThruput", &GetThruput, 
              List::create(_["class"],_["wname"]),
                           "documentation for GetThruput ");
    function( "GetLoadOpt", &GetLoadOpt,
              List::create(_["class"],_["wname"]),
              "documentation for GetLoadOpt ");
    function( "GetUtilization", &GetUtilization, 
              List::create(_["device"],_["work"],_["class"]),
              "documentation for GetUtilization ");
    function( "GetQueueLength", &GetQueueLength, 
              List::create(_["device"],_["work"],_["class"]),
              "documentation for GetQueueLength ");
    function( "GetThruMax", &GetThruMax, 
              List::create(_["class"],_["wname"]),
              "documentation for GetThruMax ");
    //    function( "GetTotalDemand", &GetTotalDemand, "documentation for GetTotalDemand ");
    function( "Init", &Init,
              List::create(_["name"]),
              "documentation for Init ");
    function( "Report", &Report, "documentation for Report");
    function( "SetDebug", &SetDebug, 
              List::create(_["flag"]),
              "documentation for SetDebug");
    function( "SetDemand", &SetDemand , 
              List::create(_["nodename"],_["workname"],_["time"]),
              "documentation for SetDemand ");
    function( "SetVisits", &SetVisits , 
              List::create(_["nodename"],_["workname"],_["visits"],_["service"]),
              "documentation for SetVisits ");
    function( "Solve", &Solve, 
              List::create(_["method"]),
              "documentation for Solve");
    function( "SetWUnit" , &SetWUnit  , 
              List::create(_["unitName"]),
              "documentation for SetWUnit " );
    function( "SetTUnit" , &SetTUnit  , 
              List::create(_["unitName"]),
              "documentation for SetTUnit " );
    function( "SetComment" , &SetComment  , 
              List::create(_["comment"]),
              "documentation for SetComment " );
    function( "GetComment" , &GetComment  , "documentation for GetComment " );
        
}                     

