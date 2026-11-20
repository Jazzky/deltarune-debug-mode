csx_lines = []

def add_csx(content):
    csx_lines.append(content)

def clear_csx():
    csx_lines.clear()

def get_csx():
    return (csx_lines)


declared_elements = []

def add_declared_elem(name):
    declared_elements.append(name)

def reset_declared_elem():
    declared_elements.clear()

def elem_declared(name):
    return (name in declared_elements)
