class widget (
    $configfile  = '/etc/widgetfile',
    $type        = $::widget,
) {

    file { $widget::configfile:
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('widget/template.file.erb'),
    }

}

