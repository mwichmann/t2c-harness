/////////////////////////////////////////////////////////////////////////////
// Copyright (C) <%year%> The Linux Foundation. All rights reserved.
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// This file contains tests for the following library: 
// <%library%>, 
// section: "<%libsection%>".
// 
// This C file was generated by the T2C system developed in ISPRAS 
// for The Linux Foundation. 
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// To build a standalone version of the tests, i.e. the one that does not
// depend on TETware Lite test harness, please follow the instructions below.
// (A standalone executable like this can prove useful for debugging.) 
// 
// 1. Make sure the T2C_ROOT and T2C_SUITE_ROOT environment variables are set properly. 
// T2C_ROOT should contain a path to the main directory of T2C Framework.
// For example, the executable of the T2C C code generator is $T2C_ROOT/t2c/bin/t2c.
// T2C_SUITE_ROOT is main test suite directory, the one where the tet execution 
// configuration file (tetexec.cfg) resides as well as tet_code file etc.
// 
// 2. If the standalone version of the tests is to be built with lsbcc or lsbc++,  
// make sure that lsbcc (or lsbc++, respectively) is somewhere in your PATH. 
// You should also add a path to the LSB pkg-config data 
// (usually /opt/lsb/lib/pkgconfig or /opt/lsb/lib64/pkgconfig) to the beginning of 
// the string contained in PKG_CONFIG_PATH environment variable.
// 
// 3. Before building the standalone version of a test, check if the following 
// files and directories exist:
//  $T2C_SUITE_ROOT/<%suite_subdir%>/tests 
//  $T2C_SUITE_ROOT/<%suite_subdir%>/tests/common.mk
//  $T2C_SUITE_ROOT/<%suite_subdir%>/tests/<%object_name%>/
//  $T2C_SUITE_ROOT/<%suite_subdir%>/tests/<%object_name%>/<%object_name%>.c
//  $T2C_SUITE_ROOT/<%suite_subdir%>/tests/<%object_name%>/Makefile
// 
// If some of these are missing, just run ./gen_code.sh script from the $T2C_SUITE_ROOT 
// directory. After that all necessary files and directories should exist.
//
// 4. Execute the following commands:
//      cd $T2C_SUITE_ROOT/<%suite_subdir%>/tests/<%object_name%>/
//      make clean
//      make debug
// 
// The C-code of the tests is the same both for release and debug (standalone)
// versions.
// main() function for standalone execution is defined in
// "$T2C_ROOT/t2c/debug/src/dbg_main.c" along with some utility stuff.
// The TET API stubs are declared in "$T2C_ROOT/t2c/debug/include/tet_api.h"
//
// Note that all the test purposes of a standalone test are executed 
// in the same process to simplify debugging (some debuggers may not 
// handle fork() calls properly by default). 
//
// WAIT_TIME configuration parameter has no effect on the standalone tests. 
// They will not be interrupted, no matter how long they run. Otherwise they 
// could be stopped in the middle of the debugging process (because their time 
// had expired) which is probably not what you want.
/////////////////////////////////////////////////////////////////////////////

#include <errno.h>
#include <unistd.h>

#include <t2c_tet_support.h>
#include <t2c.h>

#if defined(T2C_SEPARATE_PROCESSES)
#define t2c_fork_impl t2c_fork
#elif defined(T2C_DEBUG) || defined(T2C_SINGLE_PROCESS)
#define t2c_fork_impl t2c_fork_dbg
#else
#define t2c_fork_impl t2c_fork
#endif

// global variables
int nPurposesTotal = 0;      // test purpose count
int nPurposesPassed = 0;     // number of test purposes that passed
unsigned test_passed_flag = TRUE;

int bVerbose = FALSE;      

const char* test_name_      = "<%object_name%>";
const char* suite_subdir_   = "<%suite_subdir%>";

// List of requirement catalogs to be loaded
const char* rcat_names_[] = {
    "<%object_name%>",
<%rcat_names%>    NULL
};

const char* rel_href_path_  = 
    "<%suite_subdir%>/tests/<%object_name%>/<%object_name%>.html#%s%d\">";
char* t2c_href_tpl_ = NULL;
char* t2c_href_full_tpl_ = NULL;


// Name of the env. variable that is used to determine whether the REQ
// implementation should output just IDs (value = 0, default) or hyperlinks
// to the html representation, enclosed in some pseudotags for DTK Manager
// (value != 0).
const char* t2c_gen_hlinks_name = "T2C_GEN_HLINKS";
int gen_hlinks = 0;


TReqInfoList* head_ = NULL;  // A list of REQs. Use it to load and free REQs.
TReqInfoPtr*  reqs_ = NULL;  // An array of pointers to the TReqInfo structures.
int nreq_ = 0;               // Total number of REQs (length of the array).

char* init_fail_reason_ = NULL;


// function prototypes
static void test_passed();
static void startup_func();
static void cleanup_func();

static void user_startup();
static void user_cleanup();

static void tp_launcher();

// other globals 
<%globals%>

// User-defined startup instructions
static void
user_startup(int* us_failed, const char** reason)
{
    int init_failed = FALSE;
    const char* reason_to_cancel = NULL;
    
<%startup%>
    if (init_failed) *us_failed = TRUE;
    if (reason_to_cancel) *reason = reason_to_cancel;
}

// User-defined cleanup instructions
static void
user_cleanup()
{
<%cleanup%>
}
 
///////////////////////////////////////////////////////////////////////////
// Test purposes
///////////////////////////////////////////////////////////////////////////
 
<%test_purposes%>

///////////////////////////////////////////////////////////////////////////
// Specials
///////////////////////////////////////////////////////////////////////////
// This function is called for each test that passes.
static void 
test_passed()
{
    if (test_passed_flag)
    {
        nPurposesPassed++;
    }
    tet_result(TET_PASS);
}

struct tet_testlist tet_testlist[] = {
<%tet_hooks%>    {NULL, 0}
};

// The list of tests in this file. 
TTestPurposeType test_purpose_func[] = {
<%tp_funcs%>    NULL
};
    
// Parent control functions.
TParentControlFunc pc_func[] = {
<%pcf_funcs%>    NULL
};

// Test purpose launcher.
static void 
tp_launcher()
{
    int tp_ind = tet_thistest - 1;
    int result = t2c_fork_impl(
        test_purpose_func[tp_ind],  // a test purpose to launch
        pc_func[tp_ind],            // parent control func
        <%wait_time%>,              // wait time (seconds)
        NULL, NULL);
    
    if (result == -1)
    {
        tet_result(TET_UNRESOLVED);
        test_passed_flag = FALSE;
    }
    else
    {
        test_passed_flag = result;
    }
    test_passed();
}

// TET startup function
static void 
startup_func()
{
    char* tsf_verb_ = NULL;
    const char* reason_to_cancel = NULL;
    
    int init_failed = FALSE;
    
    // Determine the value of the VERBOSE variable (if present).
    char* tsf_verb_name_ = strdup("VERBOSE");
    tsf_verb_ = tet_getvar(tsf_verb_name_);
    free(tsf_verb_name_);
        
    if ((tsf_verb_ != NULL) && !strcmp(tsf_verb_, "yes"))
    {
        bVerbose = TRUE;
    }
    
    // Load requirement catalogs.
#ifndef T2C_IGNORE_RCAT_ERRORS
    int bOK = t2c_rcat_load(rcat_names_, suite_subdir_, &head_, &reqs_, &nreq_);
    if (bOK == T2C_RCAT_BAD_RCAT)
    {
        INIT_FAILED("<%object_name%>: unable to load req catalog.");
    }
    else if (bOK == T2C_RCAT_NO_RCAT)
    {
        fprintf(stderr, "None of the files containing requirement catalogs could be opened.\n");
    }
#else
    t2c_rcat_load(rcat_names_, suite_subdir_, &head_, &reqs_, &nreq_);
#endif    
    
    char* href_root = t2c_get_suite_root();
    const char* beg = "{noreplace}<a href=\"";
    char* stmp = NULL;
    
    stmp = str_sum(beg, href_root);
    t2c_href_tpl_ = str_sum(stmp, rel_href_path_);
    
    t2c_href_full_tpl_ = str_sum(t2c_href_tpl_, "%s</a>{/noreplace}");
    
    free(href_root);
    free(stmp);

    // Sort the catalog by ID. (No-op if reqs == NULL.)
    t2c_rcat_sort(reqs_, nreq_);
    
    int pcc_res = pipe(pcc_pipe_);
    if (pcc_res != 0)
    {
        INIT_FAILED("Unable to create parent-child control pipe.");
    }
    
    char* glh_tmp = getenv(t2c_gen_hlinks_name);
    if (!glh_tmp)
    {
        gen_hlinks = 0;
    }
    else
    {
        gen_hlinks = atoi(glh_tmp);
    }
    
    // Perform user-defined startup instructions.
    user_startup(&init_failed, &reason_to_cancel);
    
    if (init_failed)
    {
        // Test case initialization failed. Cancel all test purposes.
        int num_purp_ = sizeof(tet_testlist) / sizeof(tet_testlist[0]) - 1;
        int cur_purp_ = 1;
        
        init_fail_reason_ = strdup(reason_to_cancel);
        
        for (; cur_purp_ <= num_purp_; ++cur_purp_)
        {
            tet_delete(cur_purp_, init_fail_reason_);
        }
    }
    
    fprintf(stderr, "\nExecuting tests for %s\n", test_name_);
}
 
// TET cleanup function
static void 
cleanup_func()
{
    // Perform user-defined cleanup instructions.
    user_cleanup();
    
    int num_purp_ = sizeof(tet_testlist) / sizeof(tet_testlist[0]) - 1;
    
    fprintf(stderr, "\nPassed %d of %d\n", nPurposesPassed, num_purp_);
    t2c_req_info_list_clear(head_);
    free(reqs_);
    
    free(t2c_href_tpl_);    
    free(t2c_href_full_tpl_);
    free(init_fail_reason_);
    
    close(pcc_pipe_[0]);
    close(pcc_pipe_[1]);
}

// Tell TET to use startup & cleanup functions we provide.
void (*tet_startup)() = startup_func;
void (*tet_cleanup)() = cleanup_func;
