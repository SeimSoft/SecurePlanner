#include "flutter_window.h"

#include <optional>

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include "flutter/generated_plugin_registrant.h"
#include "native_drop_handler.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  // Register native drop handler so we can accept virtual Outlook drops.
  native_drop_handler_.reset(new NativeDropHandler(flutter_controller_->engine()->messenger()));
  RegisterDragDrop(GetHandle(), native_drop_handler_.get());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (native_drop_handler_) {
    RevokeDragDrop(GetHandle());
    native_drop_handler_.reset();
  }
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // When the titlebar is auto-hidden (compact/borderless mode), we MUST handle
  // WM_NCHITTEST BEFORE Flutter's HandleTopLevelWindowProc, because Flutter
  // returns HTCLIENT for the entire surface and swallows our custom
  // drag/resize hit-test.
  if (message == WM_NCHITTEST && IsTitlebarAutoHidden()) {
    return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
  }

  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  // Let base class handle the message first; it may change titlebar_auto_hidden_.
  LRESULT base_result = Win32Window::MessageHandler(hwnd, message, wparam, lparam);

  // Notify Flutter when the titlebar auto-hidden state changes (e.g., compact borderless).
  if (message == WM_SIZE && flutter_controller_ && flutter_controller_->engine()) {
    auto messenger = flutter_controller_->engine()->messenger();
    if (messenger) {
      flutter::MethodChannel<flutter::EncodableValue> channel(messenger, "window_state",
                                                               &flutter::StandardMethodCodec::GetInstance());
      bool hidden = IsTitlebarAutoHidden();
      auto args = std::make_unique<flutter::EncodableValue>(flutter::EncodableValue(hidden));
      channel.InvokeMethod("titlebarHidden", std::move(args));
    }
  }

  return base_result;
}
