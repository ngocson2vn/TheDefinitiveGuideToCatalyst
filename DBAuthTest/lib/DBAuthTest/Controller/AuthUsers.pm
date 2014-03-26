package DBAuthTest::Controller::AuthUsers;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBAuthTest::Controller::AuthUsers - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base :Chained('/') :PathPart('authusers') :CaptureArgs(0) {
	my ($self, $c) = @_;
	$c->stash(users_rs => $c->model('AuthDB::User'));
	$c->stash(roles_rs => $c->model('AuthDB::Role'));
}

sub add :Chained('base') :PathPart('add') :Args(0) {
	my ($self, $c) = @_;

	if (lc $c->req->method eq 'post') {
		my $params = $c->req->params;

		## Retrieve the users_rs stashed by the base action:
		my $users_rs = $c->stash->{users_rs};

		## Create the user:
		my $newuser = eval { 
			$users_rs->create({
				username => $params->{username},
				email    => $params->{email},
				password => $params->{password}
			});
		};

		if ($@) {
			$c->log->debug(
				"User tried to sign up with an invalid email address, redoing.. "
			);
			$c->stash(errors => {email => 'invalid'}, err => $@,
				params => $params
			);

			return;
		}
		
		## Set roles to new user
		$newuser->set_all_roles($params->{role});

		## Send the user to view the newly created user
		return $c->res->redirect($c->uri_for(
				$c->controller('AuthUsers')->action_for('profile'),
				[ $newuser->id ]
			)
		);
	}
}

sub user: Chained('base') :PathPart('') :CaptureArgs(1) {
	my ($self, $c, $userid) = @_;

	my $user = $c->stash->{users_rs}->find({ id => $userid, key => 'primary' });
	die "No such user" if (!$user);

	my $role_names = "";
	my $flag = 1;
	for my $role ($user->roles) {
		$role_names .= ($flag) ? $role->role : ", " . $role->role;
		$flag = 0;
	}

	$user->{role_names} = $role_names || "";

	$c->stash(user => $user);
}

sub profile :Chained('user') :PathPart('profile') :Args(0) {
	my ($self, $c) = @_;
}

sub edit :Chained('user') :PathPart('edit') :Args(0) {
	my ($self, $c) = @_;
	my $user = $c->stash->{user};
	my $params = $c->req->params;
	my $http_method = lc $c->req->method;

	if (lc $http_method eq 'post') {

		## Update user's email and/or password
		$user->update({
			email => $params->{email},
			password => $params->{password}
		});
		
		## Set roles to new user
		$user->set_all_roles($params->{role});

	}

	if (($http_method eq 'post') or (($http_method eq 'get') and $params->{cancel})) {
		return $c->res->redirect(
			$c->uri_for(
				$c->controller()->action_for('profile'),
				[ $user->id ]
			)
		);
	}
}

sub list :Chained('base') :PathPart('list') :Args(0) {
	my ($self, $c) = @_;
}

#sub set_roles :Chained('user') :PathPart('set_roles') :Args() {
#	my ($self, $c) = @_;
#
#	my $user = $c->stash->{user};
#	if (lc $c->req->method eq 'post') {
#
#		## Fetch all role ids submitted as a list
#		my @roles = $c->req->param('role');
#		$user->set_all_roles(@roles);
#	}
#
#	return $c->res->redirect($c->uri_for(
#		$c->controller()->action_for('profile'),
#		[ $user->id ]
#	));
#}

=encoding utf8

=head1 AUTHOR

Son Nguyen

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
