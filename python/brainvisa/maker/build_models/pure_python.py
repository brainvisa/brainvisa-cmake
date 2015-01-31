import os.path as osp

class PurePythonComponentBuild(object):
    def __init__(self, component_name, source_directory, build_directory):
        self.component_name = component_name
        self.source_directory = source_directory
        self.build_directory = build_directory
        self.pth_path = osp.join(self.build_directory, 'python', 'pure_python.pth')

    def configure(self):
        if osp.exists(self.pth_path):
            directories = open(self.pth_path).read().split()
        else:
            directories = []
        if self.source_directory not in directories:
            directories.append(self.source_directory)
            open(self.pth_path,'w').write('\n'.join(directories))
        
    def build(self):
        pass