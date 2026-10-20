<div align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:00aaff,100:0055ff&height=180&section=header&text=ITSFOUR%20HUB&fontSize=40&fontColor=ffffff&fontAlignY=35&desc=Universal%20Aimbot%20%26%20ESP%20Module%20for%20Roblox&descSize=15&descAlignY=60" width="100%" alt="ITSFOUR HUB"/>

  <br>

  [🇻🇳 **Tiếng Việt**](README.md) · [🇬🇧 English](README_EN.md)

  <br>

  ![Release](https://img.shields.io/badge/Release-v3.0-00aaff?style=for-the-badge&logo=github)
  ![Roblox](https://img.shields.io/badge/Roblox-Script-00A2FF?style=for-the-badge&logo=roblox&logoColor=white)
  [![License](https://img.shields.io/badge/License-MIT-success?style=for-the-badge)](LICENSE)
  ![Lua](https://img.shields.io/badge/Language-Lua-000080?style=for-the-badge&logo=lua&logoColor=white)

  **Universal Aimbot, Triggerbot, Tracer và ESP với giao diện Glass UI.**
</div>

---

## 📖 Giới thiệu

**ITSFOUR HUB** là script Lua cho Roblox, được phát triển bởi **itsfour**. Script cung cấp giao diện tùy chỉnh để cấu hình Aimbot, Triggerbot và các tính năng hiển thị như FOV, Tracer và ESP.

> **Lưu ý về phạm vi:** Theo mã nguồn hiện tại, ESP duyệt danh sách `Players` của Roblox. Không nên quảng bá hỗ trợ NPC cho đến khi chức năng NPC thực sự được triển khai và kiểm thử.

## ✨ Tính năng

### 🎯 Aimbot
- Bật/tắt Aimbot và chọn bộ phận khóa mục tiêu: `Head`, `HumanoidRootPart` hoặc `Torso`.
- Tùy chọn kiểm tra team, trạng thái còn sống và vật cản.
- Điều chỉnh độ mượt khi khóa mục tiêu và độ nhạy điều khiển chuột.
- Tùy chọn bù hướng di chuyển (`OffsetToMoveDirection`) và điều chỉnh mức bù.
- Hỗ trợ các chế độ điều khiển camera/chuột được triển khai trong mã nguồn.

### 🔫 Triggerbot
- Bật/tắt Triggerbot.
- Tùy chọn kiểm tra team, trạng thái còn sống và chỉ kích hoạt khi đã khóa mục tiêu.
- Điều chỉnh độ trễ trước khi kích hoạt.
- Cần executor hỗ trợ các hàm mô phỏng chuột tương ứng; nếu thiếu, Triggerbot có thể không hoạt động.

### 👁️ Visuals: FOV, Tracer và ESP
- **FOV:** bật/tắt vòng FOV, điều chỉnh bán kính và màu sắc.
- **Tracer:** hiển thị đường đến mục tiêu gần nhất, tùy chỉnh màu và vị trí xuất phát.
- **ESP:** tùy chọn chấm trên đầu, tên hiển thị, khoảng cách, kích thước chữ và màu sắc.
- Tùy chọn lọc đồng đội cho ESP.

### 🎨 Giao diện và tiện ích
- Giao diện Glass UI có thể kéo thả.
- Nhấn **RightShift** để ẩn/hiện menu.
- Nút **EN/VN** chuyển đổi ngôn ngữ ngay trong GUI.
- Tự lưu một số thiết lập vào `itsfour_auto_config.json` nếu executor hỗ trợ các hàm đọc/ghi file.
- Các thiết lập được lưu không bao gồm mọi thuộc tính giao diện; một số thay đổi có thể không được khôi phục.

## 🚀 Cài đặt / Khởi chạy

1. Đưa file script lên repository của bạn.
2. Sao chép **Raw URL** chính xác của file Lua.
3. Thay URL mẫu bên dưới bằng Raw URL của bạn rồi chạy trong môi trường phù hợp.

```lua
loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
```

`YOUR_RAW_URL_HERE` chỉ là chỗ giữ chỗ, không phải URL có thể chạy trực tiếp.

## ⌨️ Điều khiển mặc định

| Phím / mục | Tác dụng |
|---|---|
| `RightShift` | Ẩn/hiện giao diện |
| Chuột phải (`MouseButton2`) | Phím kích hoạt mặc định của Aimbot |
| Nút `EN` / `VN` | Đổi ngôn ngữ giao diện |

Aimbot mặc định dùng chế độ giữ phím (`Toggle = false`). Các thiết lập có thể được thay đổi trong bảng cấu hình của script; không phải mọi tùy chọn đều có nút riêng trong GUI.

## ⚙️ Yêu cầu môi trường

Khả năng hoạt động phụ thuộc vào executor và API mà môi trường đó cung cấp. Mã nguồn sử dụng hoặc tùy chọn sử dụng một số API sau:

- `Drawing.new` để vẽ FOV, Tracer và thành phần ESP.
- `getgenv` để lưu bảng cấu hình trong môi trường thực thi.
- `getrawmetatable` cùng các hàm thao tác thuộc tính tương ứng.
- `mousemoverel` hoặc `Input.MouseMove` cho một chế độ điều khiển chuột.
- `mousemoveabs` cho chế độ di chuyển chuột tuyệt đối (nếu có).
- `mouse1press`, `mouse1release`, `mouse1click` cho Triggerbot.
- `readfile`, `writefile`, `isfile` để lưu/đọc cấu hình (tùy chọn).

Nếu executor thiếu API cần thiết, một số tính năng có thể không chạy hoặc script có thể gặp lỗi. Khả năng tương thích chưa được xác nhận trên mọi executor.

## 💾 Tệp cấu hình

Khi executor hỗ trợ thao tác file, script lưu cấu hình tại:

```text
itsfour_auto_config.json
```

Cấu hình có thể bao gồm các nhóm Aimbot, Triggerbot, Tracer, ESP, một phần thiết lập FOV và ngôn ngữ. Nên sao lưu hoặc xóa tệp này nếu cấu hình cũ gây ra hành vi không mong muốn.

## 🐛 Báo lỗi và đóng góp

Nếu gặp lỗi, hãy gửi:
- Tên executor và nền tảng đang sử dụng.
- Thông báo lỗi đầy đủ.
- Các bước tái hiện lỗi.
- Tính năng và thiết lập đang bật khi lỗi xảy ra.

Chỉ gửi thông tin cần thiết; không đính kèm cookie, token hoặc dữ liệu tài khoản cá nhân.

## 📜 Bản quyền

**Developer:** [itsfour](https://github.com/itsfourvn)

Copyright © 2026 itsfour. All rights reserved.

Hãy đọc tệp [`LICENSE`](LICENSE) trong repository để biết các điều khoản áp dụng. Không nên tuyên bố giấy phép MIT hoặc CC0 cùng lúc nếu repository chưa xác định rõ giấy phép chính thức.
