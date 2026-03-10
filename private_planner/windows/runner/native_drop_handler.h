#pragma once

#include <windows.h>
#include <oleidl.h>
#include <memory>

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/encodable_value.h>

class NativeDropHandler : public IDropTarget {
 public:
  explicit NativeDropHandler(flutter::BinaryMessenger* messenger);
  ~NativeDropHandler();

  // IUnknown
  IFACEMETHODIMP QueryInterface(REFIID riid, void** ppvObject) override;
  IFACEMETHODIMP_(ULONG) AddRef() override;
  IFACEMETHODIMP_(ULONG) Release() override;

  // IDropTarget
  IFACEMETHODIMP DragEnter(IDataObject* pDataObj, DWORD grfKeyState,
                            POINTL pt, DWORD* pdwEffect) override;
  IFACEMETHODIMP DragOver(DWORD grfKeyState, POINTL pt,
                           DWORD* pdwEffect) override;
  IFACEMETHODIMP DragLeave() override;
  IFACEMETHODIMP Drop(IDataObject* pDataObj, DWORD grfKeyState, POINTL pt,
                       DWORD* pdwEffect) override;

 private:
  std::atomic<ULONG> ref_count_{1};
  flutter::BinaryMessenger* messenger_;
};
