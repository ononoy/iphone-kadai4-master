import RealmSwift


class Task: Object{
    dynamic var id = 0
    
    dynamic var title = ""
    
    dynamic var contents = ""
    
    dynamic var date = NSDate()
    
    dynamic var category = ""
    
    override static func primaryKey() -> String?{
        return "id"
    }
}
