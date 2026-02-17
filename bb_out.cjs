const { poseidon2Hash } = require("@aztec/foundation/crypto");

const PRIME = 21888242871839275222246405745257275088548364400416034343698204186575808495617n;

(async () => {
  try {
    const inputs = process.argv.slice(2).map(s => BigInt(s) % PRIME);

    if (inputs.length === 0 || inputs.length > 9) {
      process.stderr.write("Usage: bb_out.cjs <a0> [a1] ... [a8] (1–9 inputs)\n");
      process.exit(1);
    }

    let result = poseidon2Hash(inputs);
    if (result && typeof result.then === "function") {
      result = await result;
    }

    let value;
    if (result && typeof result.toBigInt === "function") {
      value = result.toBigInt();
    } else if (typeof result === "bigint") {
      value = result;
    } else if (typeof result === "number") {
      value = BigInt(result);
    } else if (Buffer.isBuffer(result) || result instanceof Uint8Array) {
      value = BigInt("0x" + Buffer.from(result).toString("hex"));
    } else {
      const s = String(result).trim();
      value = s.startsWith("0x") || s.startsWith("0X") ? BigInt(s) : BigInt(s);
    }

    const hex = value.toString(16).padStart(64, "0");
    process.stdout.write("0x" + hex, "utf8", () => process.exit(0));

  } catch (err) {
    process.stderr.write("Error: " + (err.message || String(err)) + "\n");
    process.exit(1);
  }
})();