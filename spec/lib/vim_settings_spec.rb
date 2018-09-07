require './spec/base'

describe 'VimInstall tests' do
  describe "#build" do
    subject(:build) {VimInstall.build('/vim/clone/path', '/vim/app/path')}

    before do
      allow(VimInstall).to receive(:sh)
      allow(VimInstall).to receive(:cd)
      allow(VimInstall).to receive(:vim_make)
    end

    it do
      subject
      expect(VimInstall).to have_received(:sh).with('git clone https://github.com/vim/vim.git /vim/clone/path')
      expect(VimInstall).to have_received(:cd).with('/vim/clone/path')
      expect(VimInstall).to have_received(:vim_make).with('/vim/app/path')
    end
  end

  describe "#install" do
    subject(:install) {VimInstall.install('/vim/clone/path')}

    before do
      allow(VimInstall).to receive(:cd)
      allow(VimInstall).to receive(:make_install)
    end

    it do
      subject
      expect(VimInstall).to have_received(:cd).with('/vim/clone/path')
      expect(VimInstall).to have_received(:make_install)
    end
  end

  describe "#test" do
    subject(:install) {VimInstall.test('/vim/clone/path')}

    before do
      allow(VimInstall).to receive(:cd)
      allow(VimInstall).to receive(:make_test)
    end

    it do
      subject
      expect(VimInstall).to have_received(:cd).with('/vim/clone/path')
      expect(VimInstall).to have_received(:make_test)
    end
  end


  describe "#update" do
    subject(:update) {VimInstall.update('/vim/clone/path', '/vim/app/path')}

    before do
      allow(VimInstall).to receive(:cd)
      allow(VimInstall).to receive(:sh)
      allow(VimInstall).to receive(:make_clean)
      allow(VimInstall).to receive(:vim_make)
    end

    it do
      subject
      expect(VimInstall).to have_received(:cd).with('/vim/clone/path')
      expect(VimInstall).to have_received(:sh).with('git pull')
      expect(VimInstall).to have_received(:make_clean)
      expect(VimInstall).to have_received(:vim_make).with('/vim/app/path')
    end
  end

  describe "#dein" do
    subject(:dein) {VimInstall.dein('/vim/clone/path', '/vim/app/path')}

    context "when dein exists already" do
      before do
        allow(File).to receive(:exists?).and_return(true)
        allow(VimInstall).to receive(:cd)
        allow(VimInstall).to receive(:sh)
      end

      it do
        subject
        expect(VimInstall).to have_received(:cd).with('/vim/clone/path/dein')
        expect(VimInstall).to have_received(:sh).with('git pull')
      end
    end

    context "when dein isn't exists" do
      before do
        allow(File).to receive(:exists?).and_return(false)
        allow(VimInstall).to receive(:sh)
      end

      it do
        subject
        expect(VimInstall).to have_received(:sh).with('git clone https://github.com/Shougo/dein.vim /vim/clone/path/dein')
      end
    end
  end

  describe "#vim_make" do
    subject(:vim_make) {VimInstall.vim_make('/vim/app/path')}
    let(:expect_options) do
      "--prefix=/vim/app/path"\
      " --enable-luainterp=yes"\
      " --enable-rubyinterp=yes"\
      " --enable-multibyte"\
      " --enable-terminal"\
      " --enable-darwin"\
      " --enable-python3interp=dynamic"\
      " --enable-pythoninterp=dynamic"\
      " --with-lua-prefix=/usr/local"
    end

    before do
      allow(VimInstall).to receive(:configure)
      allow(VimInstall).to receive(:make)
    end

    it do
      subject
      expect(VimInstall).to have_received(:configure).with(expect_options)
    end
  end
end
