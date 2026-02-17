const { poseidon2Hash } = require("@aztec/foundation/crypto");

function hexlifyBytes(bytes) {
  return "0x" + Buffer.from(bytes).toString("hex");
}

function toHex(x) {
  // bigint
  if (typeof x === "bigint") return "0x" + x.toString(16);

  // number
  if (typeof x === "number") return "0x" + BigInt(x).toString(16);

  // hex string already
  if (typeof x === "string") return x.startsWith("0x") ? x : "0x" + x;

  // Buffer / Uint8Array
  if (Buffer.isBuffer(x) || x instanceof Uint8Array) return hexlifyBytes(x);

  // Common field wrappers: { value: bigint } or { value: Buffer } etc.
  if (x && typeof x === "object") {
    if ("value" in x) return toHex(x.value);
    if ("toBuffer" in x && typeof x.toBuffer === "function") return hexlifyBytes(x.toBuffer());
    if ("toString" in x && typeof x.toString === "function") {
      // some libs return decimal strings from toString()
      const s = x.toString();
      if (/^\d+$/.test(s)) return "0x" + BigInt(s).toString(16);
      if (s.startsWith("0x")) return s;
    }
  }

  throw new Error("Unsupported return type: " + Object.prototype.toString.call(x));
}

// force exactly 32-byte hex (BN254 field element canonical width)
function toHex32(x) {
  let h = toHex(x).replace(/^0x/, "");
  // if it's bytes longer than 32, it was probably bytes output; take last 32 bytes ONLY if needed
  if (h.length > 64) {
    // try interpreting as big-endian bytes and keep last 32 bytes
    h = h.slice(-64);
  }
  return "0x" + h.padStart(64, "0");
}

async function main() {
  const inputs = [1n, 2n, 3n];

  const out = await poseidon2Hash(inputs);

  console.log("raw type:", typeof out, out?.constructor?.name);
  console.log("raw out :", toHex(out));
  console.log("as 32B  :", toHex32(out));
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
