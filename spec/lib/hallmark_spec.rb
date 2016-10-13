require "spec_helper"
require "hallmark"

describe Hallmark do
  before do
    class InterfaceClass
      def self.test1; end
      def self.test2(arg1, arg2 = nil, arg3: nil); end
      def test3; end
      def test4(arg1, arg2 = nil, arg3: nil); end
    end
  end

  after do
    Object.send(:remove_const, :TestClass)
  end

  describe ".hallmarked_singleton_methods" do
    context "all singleton_methods" do
      before do
        class TestClass
          hallmarked_singleton_methods InterfaceClass
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1, 2) }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1, 2, arg3: 3) }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test3 }.to raise_error NoMethodError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end

    context "only test1" do
      before do
        class TestClass
          hallmarked_singleton_methods InterfaceClass, only: [:test1]
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NoMethodError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end

    context "expect test2" do
      before do
        class TestClass
          hallmarked_singleton_methods InterfaceClass, except: [:test2]
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NoMethodError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end
  end

  describe ".hallmarked_instance_methods" do
    context "all instance_methods" do
      before do
        class TestClass
          hallmarked_instance_methods InterfaceClass
        end
      end
      it { expect { TestClass.test1 }.to raise_error NoMethodError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1, 2) }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1, 2, arg3: 3) }.to raise_error NotImplementedError }
    end

    context "only test3" do
      before do
        class TestClass
          hallmarked_instance_methods InterfaceClass, only: [:test3]
        end
      end
      it { expect { TestClass.test1 }.to raise_error NoMethodError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end

    context "except test4" do
      before do
        class TestClass
          hallmarked_instance_methods InterfaceClass, except: [:test4]
        end
      end
      it { expect { TestClass.test1 }.to raise_error NoMethodError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end
  end

  describe ".hallmarked" do
    context "all methods" do
      before do
        class TestClass
          hallmarked InterfaceClass
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1, 2) }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1, 2, arg3: 3) }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1, 2) }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1, 2, arg3: 3) }.to raise_error NotImplementedError }
    end

    context "only test1" do
      before do
        class TestClass
          hallmarked InterfaceClass, only: [:test1]
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NoMethodError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end

    context "only test3" do
      before do
        class TestClass
          hallmarked InterfaceClass, only: [:test3]
        end
      end
      it { expect { TestClass.test1 }.to raise_error NoMethodError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end

    context "except test2" do
      before do
        class TestClass
          hallmarked InterfaceClass, except: [:test2]
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NotImplementedError }
    end

    context "except test4" do
      before do
        class TestClass
          hallmarked InterfaceClass, except: [:test4]
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end

    context "only test1 as hash" do
      before do
        class TestClass
          hallmarked InterfaceClass, only: { singleton_methods: [:test1, :test3] }
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NotImplementedError }
    end

    context "only test3 as hash" do
      before do
        class TestClass
          hallmarked InterfaceClass, only: { instance_methods: [:test1, :test3] }
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end

    context "except test2 as hash" do
      before do
        class TestClass
          hallmarked InterfaceClass, except: { singleton_methods: [:test2, :test4] }
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NoMethodError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NotImplementedError }
    end

    context "except test4 as hash" do
      before do
        class TestClass
          hallmarked InterfaceClass, except: { instance_methods: [:test2, :test4] }
        end
      end
      it { expect { TestClass.test1 }.to raise_error NotImplementedError }
      it { expect { TestClass.test2(1) }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test3 }.to raise_error NotImplementedError }
      it { expect { TestClass.new.test4(1) }.to raise_error NoMethodError }
    end
  end
end
