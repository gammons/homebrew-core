require "language/go"

class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.2.0.tar.gz"
  sha256 "13882bbbbcb86e05d6729f5bab2507de3aeabc1b4b4b34008480ee7549212c86"

  head "https://github.com/gammons/todolist.git"

  depends_on "go" => :build

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git", :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable", :revision => "9056b7a9f2d1f2d96498d6d146acd1f9d5ed3d59"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color", :revision => "87d4004f2ab62d0d255e0a38f1680aa534549fe3"
  end

  go_resource "github.com/jinzhu/now" do
    url "https://github.com/jinzhu/now",
      :revision => "d9861969c7a7e84746d341c09020c2ef8a617f8f", :using => :git
  end

  go_resource "github.com/julienschmidt/httprouter" do
    url "https://github.com/julienschmidt/httprouter",
      :revision => "77366a47451a56bb3ba682481eed85b64fea14e8", :using => :git
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/gammons/").mkpath
    ln_s buildpath, buildpath/"src/github.com/gammons/todolist"

    system "go", "build", "-o", bin/"todolist", "./src/github.com/gammons/todolist"
  end

  test do
    output = shell_output("#{bin}/todolist")
    assert_match "Todolist was lovingly crafted by Grant Ammons", output
  end
end
