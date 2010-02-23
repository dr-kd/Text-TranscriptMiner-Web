#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;

name 'Text-TranscriptMiner-Web';
all_from 'lib/Text/TranscriptMiner/Web.pm';

requires 'Catalyst::Runtime' => '5.80013';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'parent';
requires 'Config::General';
requires 'Catalyst::View::TT';
requires 'Catalyst::Plugin::SubRequest';
requires 'Template::Plugin::JSON';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
