// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

import easyMDE from "easymde"

let Hooks = {}


Hooks.easyMDE = {
    mounted() {
        const editorInstance = new easyMDE({
            element: this.el,
            forceSync: true,
            initialValue: "Hello world!",
            toolbar: ["bold", "italic", "heading", "|", "quote", "upload-image"],
            minHeight: "120px",
            status: false,
            uploadImage: true
        })
        editorInstance.codemirror.on("change", () => {
            this.pushEventTo(
                this.el,
                "change",
                { richtext_data: editorInstance.value() }
            )
        })
    }
}


Hooks.InfiniteScroll = {
    page() { return this.el.dataset.page; },
    loadMore(entries) {
        const target = entries[0];
        console.log("trigger")
        if (target.isIntersecting && this.pending == this.page()) {
            this.pending = this.page() + 1;
            this.pushEvent("next-page", {});
        }
    },
    mounted() {

        this.pending = this.page();
        this.observer = new IntersectionObserver(
            (entries) => this.loadMore(entries),
            {

                root: null, // window by default
                rootMargin: "0px",
                threshold: 0.7,
            }

        );
        this.observer.observe(this.el);
    },
    destroyed() {
        this.observer.unobserve(this.el);
    },
    updated() {
        this.pending = this.page();
    },
};





let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

