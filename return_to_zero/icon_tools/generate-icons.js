const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

const src = process.argv[2] || '../logo_wasalni.svg';
const outDir = process.argv[3] || '../app_icons';
fs.mkdirSync(outDir, { recursive: true });

const sizes = [16, 32, 48, 72, 96, 144, 192, 256, 512, 1024];
const svg = fs.readFileSync(src);

(async () => {
  for (const s of sizes) {
    const out = path.join(outDir, `icon_${s}.png`);
    await sharp(svg, { density: 200, limitInputPixels: false })
      .resize(s, s, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
      .png()
      .toFile(out);
    console.log('wrote', out);
  }
  console.log('ALL DONE ->', outDir);
})().catch((e) => { console.error('ERR', e.message); process.exit(1); });
