import Vapor

var urls: [String] = [
    "https://odisseylife.com/charcoal/",
    "https://www.emag.ro/monitor-led-ips-philips-28-4k-uhd-60hz-adaptive-sync-hdmi-displayport-288e2a-00/pd/DZBH32MBM/"
]

var currentIndex = 0
let mutex = DispatchSemaphore(value: 1)

func routes(_ app: Application) throws {
    app.get { req -> Response in
        mutex.wait()
        defer { mutex.signal() }
        if currentIndex == urls.count - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        print(currentIndex)
        let url: String = urls[currentIndex]

//        Response(status: .continue, version: <#T##HTTPVersion#>, headers: <#T##HTTPHeaders#>, body: <#T##Response.Body#>)
        return Response(status: .seeOther, headers: ["Location": url])
    }
    
    app.get("urls") { req -> Response in
        let urlList = urls.reduce(into: "") { $0 += "<p>\($1)</p>"}
        let response = Response(status: .ok,
                                headers: ["Content-Type": "text/html"],
                                body: Response.Body(string: "<html>\(urlList)</html>"))
        return response
    }
}
