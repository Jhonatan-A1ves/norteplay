import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const ignored = new Set([
  ".git",
  "node_modules",
  ".next",
  ".pnpm-store",
  ".turbo",
  ".dotnet-cli-home",
  ".nuget",
  "bin",
  "obj",
  "coverage",
  "dist",
]);
const patterns = [
  /sb_secret_[A-Za-z0-9_-]{20,}/,
  /service_role\s*[:=]\s*["']?[A-Za-z0-9._-]{24,}/i,
  /SUPABASE_SECRET_KEY\s*=\s*[^\s#]{12,}/,
];
const failures = [];

function visit(path) {
  for (const entry of readdirSync(path, { withFileTypes: true })) {
    if (ignored.has(entry.name)) continue;
    const fullPath = join(path, entry.name);
    if (entry.isDirectory()) visit(fullPath);
    else {
      const content = readFileSync(fullPath, "utf8");
      if (patterns.some((pattern) => pattern.test(content)))
        failures.push(fullPath);
    }
  }
}

visit(process.cwd());
if (failures.length) {
  console.error(`Potential secret found in: ${failures.join(", ")}`);
  process.exitCode = 1;
} else {
  console.log("Secret scan passed.");
}
