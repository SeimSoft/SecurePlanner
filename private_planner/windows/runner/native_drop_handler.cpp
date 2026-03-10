#include "native_drop_handler.h"

#include <shlobj.h>
#include <shlwapi.h>
#include <objidl.h>
#include <sstream>
#include <fstream>

using flutter::EncodableValue;
using flutter::EncodableList;
using flutter::EncodableMap;

NativeDropHandler::NativeDropHandler(flutter::BinaryMessenger* messenger)
    : messenger_(messenger) {}

NativeDropHandler::~NativeDropHandler() {}

IFACEMETHODIMP NativeDropHandler::QueryInterface(REFIID riid, void** ppvObject) {
  if (riid == IID_IUnknown || riid == IID_IDropTarget) {
    *ppvObject = static_cast<IDropTarget*>(this);
    AddRef();
    return S_OK;
  }
  *ppvObject = nullptr;
  return E_NOINTERFACE;
}

IFACEMETHODIMP_(ULONG) NativeDropHandler::AddRef() { return ++ref_count_; }
IFACEMETHODIMP_(ULONG) NativeDropHandler::Release() {
  ULONG val = --ref_count_;
  if (val == 0) delete this;
  return val;
}

IFACEMETHODIMP NativeDropHandler::DragEnter(IDataObject* pDataObj, DWORD,
                                            POINTL, DWORD* pdwEffect) {
  if (pdwEffect) *pdwEffect = DROPEFFECT_COPY;
  return S_OK;
}
IFACEMETHODIMP NativeDropHandler::DragOver(DWORD, POINTL, DWORD* pdwEffect) {
  if (pdwEffect) *pdwEffect = DROPEFFECT_COPY;
  return S_OK;
}
IFACEMETHODIMP NativeDropHandler::DragLeave() { return S_OK; }

// Helper to convert wide string to UTF-8 std::string
static std::string WideToUtf8(const std::wstring& wstr) {
  if (wstr.empty()) return {};
  int size_needed = WideCharToMultiByte(CP_UTF8, 0, wstr.c_str(), (int)wstr.size(),
                                        NULL, 0, NULL, NULL);
  std::string strTo(size_needed, 0);
  WideCharToMultiByte(CP_UTF8, 0, wstr.c_str(), (int)wstr.size(), &strTo[0],
                      size_needed, NULL, NULL);
  return strTo;
}

// Write data from an IStream to the specified file path.
static bool WriteStreamToFile(IStream* stream, const std::wstring& path) {
  if (!stream) return false;
  std::ofstream ofs(path, std::ios::binary);
  if (!ofs) return false;

  const ULONG bufSize = 4096;
  char buffer[bufSize];
  ULONG read = 0;
  HRESULT hr = S_OK;
  while (SUCCEEDED(hr)) {
    hr = stream->Read(buffer, bufSize, &read);
    if (FAILED(hr) || read == 0) break;
    ofs.write(buffer, read);
  }
  ofs.close();
  return true;
}

IFACEMETHODIMP NativeDropHandler::Drop(IDataObject* pDataObj, DWORD,
                                       POINTL, DWORD* pdwEffect) {
  if (pdwEffect) *pdwEffect = DROPEFFECT_COPY;
  if (!pDataObj) return E_INVALIDARG;

  // Try FileGroupDescriptor (Outlook virtual files).
  CLIPFORMAT cfFileGroupDescriptor = (CLIPFORMAT)RegisterClipboardFormat(CFSTR_FILEDESCRIPTORW);
  CLIPFORMAT cfFileContents = (CLIPFORMAT)RegisterClipboardFormat(CFSTR_FILECONTENTS);

  FORMATETC fmt = {cfFileGroupDescriptor, NULL, DVASPECT_CONTENT, -1, TYMED_HGLOBAL};
  STGMEDIUM stg = {};
  std::vector<std::string> saved_files;

  if (SUCCEEDED(pDataObj->GetData(&fmt, &stg))) {
    HGLOBAL h = stg.hGlobal;
    if (h) {
      FILEGROUPDESCRIPTORW* fgd = (FILEGROUPDESCRIPTORW*)GlobalLock(h);
      if (fgd) {
        for (UINT i = 0; i < fgd->cItems; ++i) {
          std::wstring filename = fgd->fgd[i].cFileName;

          // Request the file contents as an IStream
          FORMATETC fmt2 = {cfFileContents, NULL, DVASPECT_CONTENT, (LONG)i, TYMED_ISTREAM | TYMED_HGLOBAL};
          STGMEDIUM stg2 = {};
          if (SUCCEEDED(pDataObj->GetData(&fmt2, &stg2))) {
            // Create temp path
            wchar_t tempPath[MAX_PATH];
            if (GetTempPathW(MAX_PATH, tempPath) == 0) {
              // fallback to current directory
              wcscpy_s(tempPath, L".");
            }
            std::wstring outPath = std::wstring(tempPath) + filename;

            bool ok = false;
            if (stg2.tymed & TYMED_ISTREAM) {
              ok = WriteStreamToFile(stg2.pstm, outPath);
              ReleaseStgMedium(&stg2);
            } else if (stg2.tymed & TYMED_HGLOBAL) {
              HGLOBAL hg = stg2.hGlobal;
              void* data = GlobalLock(hg);
              SIZE_T size = GlobalSize(hg);
              std::ofstream ofs(outPath, std::ios::binary);
              if (ofs && data && size > 0) {
                ofs.write(reinterpret_cast<char*>(data), size);
                ofs.close();
                ok = true;
              }
              if (data) GlobalUnlock(hg);
              ReleaseStgMedium(&stg2);
            }

            if (ok) saved_files.push_back(WideToUtf8(outPath));
          }
        }
        GlobalUnlock(h);
      }
      ReleaseStgMedium(&stg);
    }
  } else {
    // Fallback to CF_HDROP (regular file drops)
    FORMATETC fmtHd = {(CLIPFORMAT)CF_HDROP, NULL, DVASPECT_CONTENT, -1, TYMED_HGLOBAL};
    STGMEDIUM stgHd = {};
    if (SUCCEEDED(pDataObj->GetData(&fmtHd, &stgHd))) {
      HDROP hdrop = (HDROP)GlobalLock(stgHd.hGlobal);
      if (hdrop) {
        UINT count = DragQueryFileW(hdrop, 0xFFFFFFFF, NULL, 0);
        for (UINT i = 0; i < count; ++i) {
          wchar_t name[MAX_PATH];
          DragQueryFileW(hdrop, i, name, MAX_PATH);
          saved_files.push_back(WideToUtf8(name));
        }
        GlobalUnlock(stgHd.hGlobal);
      }
      ReleaseStgMedium(&stgHd);
    }
  }

  // Send saved file paths to Flutter via method channel
  if (!saved_files.empty() && messenger_) {
    flutter::MethodChannel<EncodableValue> channel(messenger_, "native_drop",
                                                    &flutter::StandardMethodCodec::GetInstance());
    EncodableList list;
    for (const auto& p : saved_files) list.push_back(EncodableValue(p));
    auto args = std::make_unique<EncodableValue>(EncodableValue(list));
    channel.InvokeMethod("onFilesDropped", std::move(args));
  }

  return S_OK;
}
