class WiremockTui < Formula
  desc "Terminal UI for inspecting a running WireMock instance via its admin REST API"
  homepage "https://github.com/vplme/wiremock-tui"
  url "https://github.com/vplme/wiremock-tui/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "78eae6fe35081b787f5f5eebd982c2a9b0112f73a5e9bb23ec4fe8563541e9a1"
  license "MIT"

  # Build from source on platforms without a prebuilt binary.
  on_arm do
    on_linux do
      depends_on "rust" => :build
    end
  end

  # Prebuilt release binaries for the platforms the upstream CI builds.
  # Other platforms (e.g. arm64 Linux) fall back to building from source.
  resource "prebuilt" do
    on_macos do
      on_arm do
        url "https://github.com/vplme/wiremock-tui/releases/download/v0.0.1/wiremock-tui-v0.0.1-aarch64-apple-darwin.tar.gz"
        sha256 "3ef49f3d58b52cf11a0e06eb33f29a9c647adf264fdc183bb3b30db92c064ce6"
      end
      on_intel do
        url "https://github.com/vplme/wiremock-tui/releases/download/v0.0.1/wiremock-tui-v0.0.1-x86_64-apple-darwin.tar.gz"
        sha256 "d0034479ce269dc9762d565d02e9eef909a91929344a0727e1842731d47c757d"
      end
    end
    on_linux do
      on_intel do
        url "https://github.com/vplme/wiremock-tui/releases/download/v0.0.1/wiremock-tui-v0.0.1-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "671f12c89f830ed5e144d77984a6904a4fe1b7286bcfad886de8ed9bea9c1798"
      end
    end
  end

  def install
    if (prebuilt = resource("prebuilt")).url.present?
      prebuilt.stage do
        bin.install "wiremock-tui"
      end
    else
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "wiremock-tui", shell_output("#{bin}/wiremock-tui --version")
  end
end
