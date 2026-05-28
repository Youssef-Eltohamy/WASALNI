const sharp = require('sharp');
const fs = require('fs');

const input = process.argv[2];
const output = process.argv[3] || input.replace(/\.svg$/, '.png');
const size = parseInt(process.argv[4] || '600', 10);

const svg = fs.readFileSync(input);
sharp(svg, { density: 384 })
  .resize(size, size, { fit: 'contain', background: { r: 20, g: 20, b: 24, alpha: 1 } })
  .png()
  .toFile(output)
  .then(() => console.log('wrote', output, size + 'px'))
  .catch((e) => { console.error('ERR', e.message); process.exit(1); });
