#include "App.h"

int main() {
    /* ws->getUserData returns one of these */
    struct PerSocketData {
        /* Fill with user data */
    };
    uWS::HttpResponse<false> *global_res = nullptr;

    uWS::App()
        .get("/",
             [ &global_res](auto *res, auto *req) {
               if (global_res != nullptr) {
                 global_res->write("data: reload\n\n");
               } else {
               }
               res->end("");
             })
        .get("/eventsource",
             [&global_res](auto *res, auto *req) {
               res->writeHeader("Content-Type", "text/event-stream");
               res->writeHeader("Cache-Control", "no-cache");
               res->writeHeader("Connection", "keep-alive");
               res->writeHeader("Access-Control-Allow-Origin", "*");
               global_res = res;
               res->onAborted([&global_res]() {
                   global_res = nullptr;
                   });
             })
        .listen(9001,
                [](auto *token) {
                  if (token) {
                    std::cout << "Listening on port " << 9001 << std::endl;
                  }
                })
        .run();
}
