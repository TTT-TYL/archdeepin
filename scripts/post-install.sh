#!/bin/bash
echo "正在配置系统..."

# 1. 配置引导工具 (GRUB)
echo "安装 GRUB 引导..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux --recheck || true
grub-mkconfig -o /boot/grub/grub.cfg

# 2. 配置网络
echo "启用 NetworkManager..."
systemctl enable NetworkManager

# 3. 配置 Deepin 显示管理器
echo "配置 Deepin 登录界面..."
systemctl enable lightdm

# 4. 配置用户
echo "创建用户..."
useradd -m -G wheel -s /bin/bash archuser
echo "archuser:arch" | chpasswd # 默认密码 arch
echo "root:root" | chpasswd     # 默认密码 root

# 5. 配置 sudo 免密 (为了演示方便，生产环境可删除)
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# 6. 配置国内镜像源更新工具 (Reflector)
echo "配置 Reflector 自动更新源..."
cat > /etc/xdg/autostart/reflector.desktop << EOF
[Desktop Entry]
Type=Application
Name=Reflector
Exec=sudo reflector --country 'China' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

echo "配置完成！"

