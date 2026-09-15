//
//  TrailerPlayerView.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI
import WebKit

struct TrailerPlayerView: View {

    let video: Video

    @State private var didFail = false
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            if didFail {
                fallback
            } else {
                YouTubeWebView(videoKey: video.key) {
                    didFail = true
                }
            }
        }
    }

    private var fallback: some View {
        Button {
            if let url = video.youTubeURL { openURL(url) }
        } label: {
            VStack(spacing: 10) {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 44))
                Text("Watch trailer on YouTube")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
        }
    }
}

private struct YouTubeWebView: UIViewRepresentable {

    let videoKey: String
    let onFailure: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        configuration.userContentController.add(context.coordinator, name: "player")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard context.coordinator.loadedKey != videoKey else { return }
        context.coordinator.loadedKey = videoKey

        guard let originURL = URL(string: "https://www.youtube.com") else { return }
        let request = URLRequest(url: originURL)
        webView.loadSimulatedRequest(request, responseHTML: Self.embedHTML(for: videoKey))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onFailure: onFailure)
    }

    private static func embedHTML(for key: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; }
                html, body { background-color: #000; height: 100%; overflow: hidden; }
                #player { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
            </style>
        </head>
        <body>
            <div id="player"></div>
            <script>
                function onYouTubeIframeAPIReady() {
                    new YT.Player('player', {
                        width: '100%',
                        height: '100%',
                        videoId: '\(key)',
                        playerVars: {
                            playsinline: 1,
                            rel: 0,
                            modestbranding: 1,
                            origin: 'https://www.youtube.com'
                        },
                        events: {
                            onError: function(e) {
                                window.webkit.messageHandlers.player.postMessage('error');
                            }
                        }
                    });
                }
            </script>
            <script src="https://www.youtube.com/iframe_api"></script>
        </body>
        </html>
        """
    }

    final class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {

        var loadedKey: String?
        private let onFailure: () -> Void

        init(onFailure: @escaping () -> Void) {
            self.onFailure = onFailure
        }

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            reportFailure()
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            reportFailure()
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            reportFailure()
        }

        private func reportFailure() {
            Task { @MainActor in self.onFailure() }
        }
    }
}
