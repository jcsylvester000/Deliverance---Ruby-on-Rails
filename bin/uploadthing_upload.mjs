// Server-side UploadThing uploader, invoked by Rails (UploadthingService via Open3).
// Usage: node bin/uploadthing_upload.mjs <filePath> <fileName> <contentType>
// Reads UPLOADTHING_TOKEN from the environment. Prints one line of JSON: {key,url,name,size}.
import { UTApi, UTFile } from "uploadthing/server";
import { readFile } from "node:fs/promises";

async function main() {
  const [, , filePath, fileName, contentType] = process.argv;

  if (!process.env.UPLOADTHING_TOKEN) {
    process.stderr.write(JSON.stringify({ error: "UPLOADTHING_TOKEN is not set" }));
    process.exit(1);
  }
  if (!filePath || !fileName) {
    process.stderr.write(JSON.stringify({ error: "usage: uploadthing_upload.mjs <filePath> <fileName> [contentType]" }));
    process.exit(1);
  }

  const utapi = new UTApi(); // reads UPLOADTHING_TOKEN from env
  const bytes = await readFile(filePath);
  const file = new UTFile([bytes], fileName, { type: contentType || "application/octet-stream" });

  const res = await utapi.uploadFiles(file);
  if (res.error) {
    process.stderr.write(JSON.stringify({ error: res.error.message || String(res.error) }));
    process.exit(1);
  }

  const d = res.data;
  process.stdout.write(JSON.stringify({
    key:  d.key,
    url:  d.ufsUrl ?? d.url ?? d.appUrl,
    name: d.name,
    size: d.size
  }));
}

main().catch((e) => {
  process.stderr.write(JSON.stringify({ error: e?.message || String(e) }));
  process.exit(1);
});
