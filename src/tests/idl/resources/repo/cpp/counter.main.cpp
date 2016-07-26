// apps
# include "counter.app.example.h"

#ifdef _WIN32
# include <windows.h>

void mysleep()
{
    Sleep(3000);
}
#else
#include <unistd.h>

void mysleep()
{
    sleep(3);
}
#endif

void dsn_app_registration_counter()
{
    // register all possible service apps
    dsn::register_app< ::dsn::example::counter_server_app>("server");
    dsn::register_app< ::dsn::example::counter_client_app>("client");
    dsn::register_app< ::dsn::example::counter_perf_test_client_app>("client.perf.counter");
}

# ifndef DSN_RUN_USE_SVCHOST

int main(int argc, char** argv)
{
    dsn_app_registration_counter();

    dsn_run_config(argv[1], false);
    mysleep();
    dsn_exit(0);
}

# else

# include <dsn/internal/module_int.cpp.h>

MODULE_INIT_BEGIN(counter)
    dsn_app_registration_counter();
MODULE_INIT_END

# endif
