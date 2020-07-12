#include "App.h"

int main() {
    /* ws->getUserData returns one of these */
    struct PerSocketData {
        /* Fill with user data */
    };
    uWS::WebSocket<false, true> *global_ws = nullptr;
    
    uWS::App()
      .get("/", [&global_ws](auto *res, auto *req) {
          if (global_ws != nullptr) {
            global_ws->send("refresh", uWS::OpCode::TEXT);
          }
          res->end("");
      })
      .ws<PerSocketData>("/*", {
        /* Settings */
        .compression = uWS::SHARED_COMPRESSOR,
        .maxPayloadLength = 16 * 1024,
        .idleTimeout = 10,
        .maxBackpressure = 1 * 1024 * 1024,
        /* Handlers */
        .open = [&global_ws](auto *ws) {
            /* Open event here, you may access ws->getUserData() which points to a PerSocketData struct */
            global_ws = ws;
        },
        .message = [](auto *ws, std::string_view message, uWS::OpCode opCode) {
            // Echo
            ws->send(message, opCode, true);
        },
        .drain = [](auto *ws) {
            /* Check ws->getBufferedAmount() here */
        },
        .ping = [](auto *ws) {
            /* Not implemented yet */
        },
        .pong = [](auto *ws) {
            /* Not implemented yet */
        },
        .close = [&global_ws](auto *ws, int code, std::string_view message) {
            global_ws = nullptr;
        }
    }).listen(9001, [](auto *token) {
        if (token) {
            std::cout << "Listening on port " << 9001 << std::endl;
        }
    }).run();
}
