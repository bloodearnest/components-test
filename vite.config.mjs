/* eslint-disable import/no-extraneous-dependencies */
import react from "@vitejs/plugin-react-swc";
import { viteStaticCopy } from "vite-plugin-static-copy";

var env = process.env;

/**
 * @type {import('vite').UserConfig}
 */
const config = {
  base: "/static/",
  build: {
    manifest: true,
    rollupOptions: {
      input: {
        base: `${env.ASSET_SRC}/scripts/base.js`,
        components: `${env.ASSET_SRC}/scripts/components.js`,
        modal: "./components/templates/_components/modal/modal.js",
        multiselect: "./components/templates/_components/multiselect/multiselect.js",
      },
    },
    outDir: env.ASSET_DIST,
    emptyOutDir: true,
  },
  server: {
    origin: "http://localhost:5173",
  },
  clearScreen: false,
  plugins: [
    /*react(),
    viteStaticCopy({
      targets: [
        {
          src: "./node_modules/htmx.org/dist/htmx.min.js",
          dest: "vendor",
        },
      ],
    }),
    */
  ],
  test: {}
};

export default config;
