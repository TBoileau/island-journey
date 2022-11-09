<?php

declare(strict_types=1);

namespace App\Controller\Admin;

use App\Entity\Activity;
use App\Form\ParameterType;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\CollectionField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

final class ActivityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Activity::class;
    }
    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Activité')
            ->setEntityLabelInPlural('Activités')
            ->setDefaultSort(['name' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name', 'nom');
        yield NumberField::new('lat', 'Latitude')->setNumDecimals(12);
        yield NumberField::new('lng', 'Longitude')->setNumDecimals(12);
        yield TextEditorField::new('description', 'Description');
    }
}
