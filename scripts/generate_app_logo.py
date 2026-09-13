import os
import math
from PIL import Image, ImageDraw, ImageFilter

def create_anatomia_logo(size=512):
    # Create RGBA canvas
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    cx, cy = size / 2, size / 2
    r_outer = size * 0.45

    # 1. Background glow circle
    glow = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    for i in range(15):
        alpha = int(40 * (1 - i / 15))
        rad = r_outer + i * 2.5
        glow_draw.ellipse(
            [cx - rad, cy - rad, cx + rad, cy + rad],
            outline=(0, 194, 255, alpha),
            width=2
        )
    glow = glow.filter(ImageFilter.GaussianBlur(8))
    img = Image.alpha_composite(img, glow)
    draw = ImageDraw.Draw(img)

    # 2. Main circular base plate with dark navy / blue gradient
    base = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    base_draw = ImageDraw.Draw(base)
    base_draw.ellipse(
        [cx - r_outer, cy - r_outer, cx + r_outer, cy + r_outer],
        fill=(10, 18, 36, 255),
        outline=(0, 194, 255, 255),
        width=int(size * 0.015)
    )

    # Add gradient overlay
    for y in range(int(cy - r_outer), int(cy + r_outer)):
        factor = (y - (cy - r_outer)) / (2 * r_outer)
        r = int(6 + factor * 0)
        g = int(25 + factor * 60)
        b = int(70 + factor * 130)
        # Inner mask
        dx = math.sqrt(max(0, r_outer**2 - (y - cy)**2))
        base_draw.line(
            [(cx - dx + 5, y), (cx + dx - 5, y)],
            fill=(r, g, b, 230)
        )

    # Re-stroke border
    base_draw.ellipse(
        [cx - r_outer, cy - r_outer, cx + r_outer, cy + r_outer],
        outline=(0, 220, 255, 255),
        width=int(size * 0.015)
    )

    img = Image.alpha_composite(img, base)
    draw = ImageDraw.Draw(img)

    # 3. Concentric futuristic tech tick rings
    for angle_deg in range(0, 360, 15):
        rad = math.radians(angle_deg)
        inner_r = r_outer * 0.88
        outer_r = r_outer * 0.94
        x1 = cx + inner_r * math.cos(rad)
        y1 = cy + inner_r * math.sin(rad)
        x2 = cx + outer_r * math.cos(rad)
        y2 = cy + outer_r * math.sin(rad)
        draw.line([(x1, y1), (x2, y2)], fill=(0, 210, 255, 160), width=2)

    # 4. Stylized Anatomical Human Body Silhouette
    # Head
    head_cy = cy - size * 0.16
    head_r = size * 0.08
    draw.ellipse(
        [cx - head_r, head_cy - head_r, cx + head_r, head_cy + head_r],
        fill=(240, 248, 255, 255),
        outline=(0, 210, 255, 255),
        width=3
    )

    # Torso
    torso_top = head_cy + head_r + 4
    torso_bottom = cy + size * 0.18
    torso_w = size * 0.22

    # Draw shoulder & chest polygon
    chest = [
        (cx - torso_w * 0.85, torso_top + 14),
        (cx - torso_w * 0.45, torso_top + 4),
        (cx + torso_w * 0.45, torso_top + 4),
        (cx + torso_w * 0.85, torso_top + 14),
        (cx + torso_w * 0.55, cy + size * 0.08),
        (cx + torso_w * 0.35, torso_bottom),
        (cx - torso_w * 0.35, torso_bottom),
        (cx - torso_w * 0.55, cy + size * 0.08),
    ]
    draw.polygon(chest, fill=(240, 248, 255, 240), outline=(0, 194, 255, 255))

    # Ribcage lines
    for i in range(4):
        rib_y = cy - size * 0.04 + (i * size * 0.04)
        rw = (size * 0.14) * (1 - i * 0.15)
        draw.arc(
            [cx - rw, rib_y - 6, cx + rw, rib_y + 14],
            start=20, end=160,
            fill=(0, 102, 255, 255),
            width=3
        )

    # Spine line
    draw.line([(cx, torso_top + 6), (cx, torso_bottom)], fill=(0, 102, 255, 200), width=4)

    # Glowing Red Heart in chest
    heart_x = cx + size * 0.02
    heart_y = cy - size * 0.02
    heart_r = size * 0.045

    # Heart glow
    for g in range(6):
        draw.ellipse(
            [heart_x - heart_r - g * 3, heart_y - heart_r - g * 3,
             heart_x + heart_r + g * 3, heart_y + heart_r + g * 3],
            outline=(255, 23, 68, int(150 * (1 - g / 6))),
            width=2
        )
    draw.ellipse(
        [heart_x - heart_r, heart_y - heart_r, heart_x + heart_r, heart_y + heart_r],
        fill=(255, 23, 68, 255)
    )

    # "3D" modern badge at bottom
    badge_w = size * 0.22
    badge_h = size * 0.09
    badge_x = cx - badge_w / 2
    badge_y = cy + size * 0.22

    draw.rounded_rectangle(
        [badge_x, badge_y, badge_x + badge_w, badge_y + badge_h],
        radius=14,
        fill=(0, 102, 255, 255),
        outline=(0, 220, 255, 255),
        width=2
    )

    # Draw "3D" text manually with crisp geometry
    # 3
    t3_x = cx - size * 0.045
    t3_y = badge_y + badge_h * 0.25
    draw.line([(t3_x - 12, t3_y), (t3_x + 8, t3_y)], fill=(255, 255, 255, 255), width=4)
    draw.line([(t3_x + 8, t3_y), (t3_x, t3_y + 12)], fill=(255, 255, 255, 255), width=4)
    draw.line([(t3_x, t3_y + 12), (t3_x + 8, t3_y + 12)], fill=(255, 255, 255, 255), width=4)
    draw.line([(t3_x + 8, t3_y + 12), (t3_x + 8, t3_y + 24)], fill=(255, 255, 255, 255), width=4)
    draw.line([(t3_x + 8, t3_y + 24), (t3_x - 12, t3_y + 24)], fill=(255, 255, 255, 255), width=4)

    # D
    td_x = cx + size * 0.035
    draw.line([(td_x - 6, t3_y), (td_x - 6, t3_y + 24)], fill=(255, 255, 255, 255), width=4)
    draw.arc([td_x - 12, t3_y, td_x + 12, t3_y + 24], start=-90, end=90, fill=(255, 255, 255, 255), width=4)

    return img

def main():
    os.makedirs('assets/icons', exist_ok=True)
    logo_512 = create_anatomia_logo(512)
    logo_512.save('assets/icons/app_logo.png')
    print("Generated assets/icons/app_logo.png")

    # Mipmap sizes for Android Launcher Icon
    mipmaps = {
        'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': 48,
        'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': 72,
        'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': 96,
        'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': 144,
        'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': 192,
    }

    for path, res in mipmaps.items():
        os.makedirs(os.path.dirname(path), exist_ok=True)
        resized = logo_512.resize((res, res), Image.Resampling.LANCZOS)
        resized.save(path)
        print(f"Generated {path} ({res}x{res})")

if __name__ == '__main__':
    main()
