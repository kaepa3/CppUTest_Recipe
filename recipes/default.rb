#
# Cookbook Name:: CppUTest
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "apt-get-update-periodic" do
  code "apt-get update"
  ignore_failure true
end

#CppUTestのコンパイルに必要なモジュールのインストール
%w(g++ automake autoconf libtool git).each do |package|
  package  "#{package}" do
    action :install
  end
end

#CppUTestのリポジトリをcloneする
git "/home/.CppUTest" do
  repository "git://github.com/cpputest/cpputest.git"
  reference "master"
  action :checkout
  enable_checkout false
end
#Makefileの自動生成、コンパイル、lib、includeの配備
bash "Makefile Generate" do
  not_if { File.exists?("/usr/local/lib/libCppUTest.a") }
  cwd "/home/.CppUTest/cpputest_build"
  code <<-EOS
    autoreconf .. -i
    ../configure
    make install
  EOS
  action :run
end
