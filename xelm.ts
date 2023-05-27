#!/usr/bin/env -S deno run -A
import { cli } from "xelm";
await cli(Deno.args.concat("--transform", "--test"));
