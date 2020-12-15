package devskiller

import input as tfplan

# default number of instances
test_instance_type {
    aws_instances[_].change.after.instance_type == "c5.large"
}

aws_instances = all {
    all := [i |
        i:= tfplan.resource_changes[_]
        i.type == "aws_instance"
        i.change.actions[_] == "create"
    ]
}