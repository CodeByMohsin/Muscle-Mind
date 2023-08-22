// // smooth scrolling 

// const lenis = new Lenis()

// lenis.on('scroll', (e) => {
//     // console.log(e)
// })

// function raf(time) {
//     lenis.raf(time)
//     requestAnimationFrame(raf)
// }

// requestAnimationFrame(raf)

// cursor follow Animation

var cursor = document.querySelector("#cursor")
var cursorShadow = document.querySelector("#cursor-shadow")

document.addEventListener("mousemove", function (mousePostion) {
    cursorShadow.style.left = mousePostion.x - 200 + "px"
    cursorShadow.style.top = mousePostion.y - 200 + "px"

    cursor.style.left = mousePostion.x - 10 + "px"
    cursor.style.top = mousePostion.y + -10 + "px"
})

// nav scroll backgroundColor change 

gsap.to("#nav", {
    backgroundColor: "#000",
    height: "104px",
    duration: 0.5,
    scrollTrigger: {
        trigger: "#nav",
        scroller: "body",
        start: "top -8%",
        scrub: .8
    }
})

// Mein backgroundColor changed on scroll 

gsap.to("#leading_page_main", {
    backgroundColor: "#000",
    scrollTrigger: {
        trigger: "#leading_page_main",
        scroller: "body",
        start: "top -30%",
        end: "top -80%",
        scrub: 1
    }
})

// pause and play video on scrolling 

let videoElem = document.querySelector('video')

gsap.to(videoElem, {
    scrollTrigger: {
        trigger: videoElem,
        scroller: "body",
        start: "70% 10%",
        end: "200 5%",
        onEnter: () => videoElem.play(),
        onEnterBack: () => videoElem.play(),
        onLeave: () => videoElem.pause(),
        onLeaveBack: () => videoElem.play(),
        //   markers: true,
    }
})