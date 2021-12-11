extends Object
class_name AABB_Summer


var total_aabb_center_gt
var total_aabb_center_t
var total_aabb_size
var total_aabb_longest_axis_length
# use only when scanning build for portal porting or shield matting
#Don't update total_aabb when porting or while shield is active
#prep build first for porting:
#scan build to envelope it with portal stabilizing field

func update_total_aabb(nd):
	var total_aabb = null
	total_aabb = construct_total_aabb(nd,total_aabb)
	if(!total_aabb):
		return
	total_aabb_size = total_aabb.size
	total_aabb_center_gt = total_aabb.position + (total_aabb.size/2)
	total_aabb_center_t = nd.transform.xform_inv(total_aabb_center_gt)
	total_aabb_longest_axis_length = total_aabb.get_longest_axis_size()
	
	prints(nd.name,"aabb",total_aabb_center_gt,total_aabb_center_t,total_aabb_size,total_aabb_longest_axis_length)



func construct_total_aabb(nd,aabb):
	if(nd.is_in_group("debug_mesh")): ### make sure all debug meshes don't have children
		return aabb
	if(nd is MeshInstance):
			if(!aabb):
				aabb = nd.get_transformed_aabb()
			else:
				aabb = aabb.merge(nd.get_transformed_aabb())

	if(nd.get_child_count() > 0):
		for c in nd.get_children():
			aabb = construct_total_aabb(c,aabb)

	return aabb





func find_body_center_t(nd): #ignores legs spawning in awkward position
	var total_aabb = null
	total_aabb = construct_total_aabb_but_ignore_group("leg_mesh",nd,total_aabb)
	if(!total_aabb):
		return null
	total_aabb_center_gt = total_aabb.position + (total_aabb.size/2)
	total_aabb_center_t = nd.transform.xform_inv(total_aabb_center_gt)
	
	prints(nd.name,"body center: ",total_aabb_center_t)
	return total_aabb_center_t
	
func construct_total_aabb_but_ignore_group(x_group,nd,aabb):
	if(nd.is_in_group("debug_mesh") || nd.is_in_group(x_group)): ### make sure all debug meshes don't have children
		
		return aabb
	if(nd is MeshInstance):
			if(!aabb):
				aabb = nd.get_transformed_aabb()
			else:
				aabb = aabb.merge(nd.get_transformed_aabb())

	if(nd.get_child_count() > 0):
		for c in nd.get_children():
			aabb = construct_total_aabb_but_ignore_group(x_group,c,aabb)

	return aabb


