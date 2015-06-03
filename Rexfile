use Rex::Commands::SCM;
use Rex::Commands::Host;

desc 'Instala los paquetes necesarios';
task 'InstalarPaquetes', sub {
    my @paquetes = qw(
        httpd git php php-cli php-mysql php-process php-devel php-gd php-pecl-apc php-pecl-json php-mbstring mariadb-server mariadb subversion
        );
    pkg \@paquetes, 
            ensure => 'present';

    # Instalar PEAR
    run 'curl -L http://pear.php.net/go-pear.phar | php', sub {
        my ($stdout, $stderr) = @_;
        Rex::Logger::info($stdout);
        Rex::Logger::info($stderr);
    };

    run 'pecl install apc', sub {
        my ($stdout, $stderr) = @_;
        Rex::Logger::info($stdout);
        Rex::Logger::info($stderr);
    };
};

desc 'Configurar apache';
task 'ConfigurarApache', sub {

    service 'httpd',
        ensure => 'stopped';

    file '/etc/httpd/conf.d/phabricator.conf',
        source => 'archivos/phabricator.conf',
        owner => 'root',
        group => 'root',
        mode => 644;

    service 'httpd',
        ensure => 'started';
};

desc 'Configurar MariaDB';
task 'ConfigurarMariaDB', sub {
    run '/phabricator/bin/phd stop', sub {
        my ($stdout, $stderr) = @_;
        Rex::Logger::info($stdout);
        Rex::Logger::info($stderr);
    };
    service 'httpd',
        ensure => 'stopped'; 
    service 'mariadb',
        ensure => 'started';
    run '/phabricator/bin/storage upgrade --force', sub {
        my ($stdout, $stderr) = @_;
        Rex::Logger::info($stdout);
        Rex::Logger::info($stderr);
    };
    run '/phabricator/bin/phd start', sub {
        my ($stdout, $stderr) = @_;
        Rex::Logger::info($stdout);
        Rex::Logger::info($stderr);
    };
    service 'httpd',
        ensure => 'started'; 
};



desc 'Obtiene el código fuente de phabricator';
task 'ObtenerCodigoFuente', sub {
    set repository => 'PHUtil',
        url => 'https://github.com/phacility/libphutil.git',
        type => 'git';
    set repository => 'Arcanist',
        url => 'https://github.com/phacility/arcanist.git',
        type => 'git';
    set repository => 'Phabricator',
        url => 'https://github.com/phacility/phabricator.git',
        type => 'git';

    checkout 'PHUtil',
     path => '/libphutil';
    checkout 'Arcanist',
     path => '/arcanist';
    checkout 'Phabricator',
     path => '/phabricator';
 
};

desc 'Configuración de phabricator';
task 'ConfigurarPhabricator', sub {
    InstalarPaquetes();
    ConfigurarApache();
    ObtenerCodigoFuente();
    ConfigurarMariaDB();
};

task 'IntroducirHost', sub {
    host_entry 'eolica.local',
   ensure    => 'present',
   ip        => '192.168.33.10';
};

task 'PrepararMaquinaVirtual', sub {
    run 'vagrant up';
};

task 'AliasLocal', sub {
    
    host_entry 'phabricator.example.org',
        ensure    => 'present',
        ip        => '127.0.0.1';
};

task 'EliminarAliasLocal', sub {
    
    host_entry 'phabricator.example.org',
        ensure    => 'absent',
        ip        => '127.0.0.1';
};
